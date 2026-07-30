// SPDX-FileCopyrightText: 2018-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Foundation
import Synchronization
import Testing

@testable import Genos

/// URLProtocol stub: `handler` maps each request to (status, data); every request
/// is recorded for assertions.
private final class StubProtocol: URLProtocol {
  static let handler = Mutex<(@Sendable (URLRequest) -> (Int, Data))?>(nil)
  static let requests = Mutex<[URLRequest]>([])

  static func reset(_ newHandler: @escaping @Sendable (URLRequest) -> (Int, Data)) {
    handler.withLock { $0 = newHandler }
    requests.withLock { $0.removeAll() }
  }

  override class func canInit(with request: URLRequest) -> Bool { true }

  override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

  override func startLoading() {
    Self.requests.withLock { $0.append(request) }
    guard let handler = Self.handler.withLock({ $0 }) else {
      client?.urlProtocol(self, didFailWithError: URLError(.unsupportedURL))
      return
    }
    let (status, data) = handler(request)
    let response = HTTPURLResponse(
      url: request.url!, statusCode: status, httpVersion: nil, headerFields: nil)!
    client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
    client?.urlProtocol(self, didLoad: data)
    client?.urlProtocolDidFinishLoading(self)
  }

  override func stopLoading() {}
}

/// A `Sendable` mutable box for cross-task assertions in tests.
private final class Box<Value: Sendable>: Sendable {
  private let mutex: Mutex<Value>

  init(_ value: Value) {
    mutex = Mutex(value)
  }

  var value: Value {
    get { mutex.withLock { $0 } }
    set { mutex.withLock { $0 = newValue } }
  }
}

private struct User: Codable, Equatable {
  let name: String
}

@Suite(.serialized)
struct HttpTests {
  private func makeHttp(
    onUnauthorized: (@Sendable () async -> Bool)? = nil
  ) -> Http {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [StubProtocol.self]
    return Http(
      baseURL: URL(string: "https://example.com/api/")!,
      session: URLSession(configuration: configuration),
      onUnauthorized: onUnauthorized)
  }

  /// Reads a recorded request's body: URLProtocol exposes it as a stream.
  private func body(of request: URLRequest) -> Data {
    guard let stream = request.httpBodyStream else { return request.httpBody ?? Data() }
    stream.open()
    defer { stream.close() }
    var data = Data()
    var buffer = [UInt8](repeating: 0, count: 1024)
    while stream.hasBytesAvailable {
      let read = stream.read(&buffer, maxLength: buffer.count)
      guard read > 0 else { break }
      data.append(contentsOf: buffer[..<read])
    }
    return data
  }

  @Test func authHeaderIsInjected() async throws {
    Global.authToken = "token-123"
    defer { Global.authToken = "" }
    StubProtocol.reset { _ in (200, Data(#"{"name":"NY"}"#.utf8)) }
    let user: User = try await makeHttp().get("users/me")
    #expect(user == User(name: "NY"))
    let header = StubProtocol.requests.withLock {
      $0.first?.value(forHTTPHeaderField: "Authorization")
    }
    #expect(header == "Bearer token-123")
  }

  @Test func unauthorizedPolicyRefreshesAndRetriesOnce() async throws {
    StubProtocol.reset { _ in
      StubProtocol.requests.withLock { $0.count } == 1
        ? (401, Data())
        : (200, Data(#"{"name":"NY"}"#.utf8))
    }
    let refreshed = Box(false)
    let http = makeHttp {
      refreshed.value = true
      return true
    }
    let user: User = try await http.get("users/me")
    #expect(user == User(name: "NY"))
    #expect(refreshed.value)
    #expect(StubProtocol.requests.withLock { $0.count } == 2)
  }

  @Test func decliningPolicyThrowsWithoutRetry() async {
    StubProtocol.reset { _ in (401, Data()) }
    let http = makeHttp { false }
    do {
      let _: User = try await http.get("users/me")
      Issue.record("expected HttpError")
    } catch let error as HttpError {
      #expect(error.status == 401)
    } catch {
      Issue.record("unexpected error: \(error)")
    }
    #expect(StubProtocol.requests.withLock { $0.count } == 1)
  }

  @Test func globalHookFiresWhenNoPolicyIsSet() async {
    StubProtocol.reset { _ in (401, Data()) }
    let fired = Box(false)
    Global.onUnauthorized = { fired.value = true }
    defer { Global.onUnauthorized = {} }
    do {
      let _: User = try await makeHttp().get("users/me")
      Issue.record("expected HttpError")
    } catch {
      #expect((error as? HttpError)?.status == 401)
    }
    #expect(fired.value)
  }

  @Test func failureStatusBecomesHttpErrorWithDescription() async {
    StubProtocol.reset { _ in (404, Data("user not found".utf8)) }
    do {
      let _: User = try await makeHttp().get("users/none")
      Issue.record("expected HttpError")
    } catch let error as HttpError {
      #expect(error.status == 404)
      #expect(error.body == "user not found")
      #expect(error.errorDescription == "HTTP 404: user not found")
      #expect(error.localizedDescription == "HTTP 404: user not found")
    } catch {
      Issue.record("unexpected error: \(error)")
    }
  }

  @Test func invalidPathThrows() async {
    StubProtocol.reset { _ in (200, Data()) }
    do {
      try await makeHttp().post("")
      Issue.record("expected InvalidPathError")
    } catch let error as InvalidPathError {
      #expect(error.path.isEmpty)
    } catch {
      Issue.record("unexpected error: \(error)")
    }
    #expect(StubProtocol.requests.withLock { $0.isEmpty })
  }

  @Test func bodyIsEncodedAsJSON() async throws {
    StubProtocol.reset { _ in (201, Data()) }
    try await makeHttp().post("users", body: User(name: "NY"))
    let request = try #require(StubProtocol.requests.withLock { $0.first })
    #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/json")
    let decoded = try JSONDecoder().decode(User.self, from: body(of: request))
    #expect(decoded == User(name: "NY"))
  }
}
