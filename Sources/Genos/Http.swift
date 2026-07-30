// SPDX-FileCopyrightText: 2018-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Foundation

/// A non-2xx HTTP response: status code plus the raw response body.
public struct HttpError: Error {
  public let status: Int
  public let body: String

  public init(status: Int, body: String) {
    self.status = status
    self.body = body
  }
}

extension HttpError: LocalizedError {
  /// "HTTP <status>" plus the response body truncated to 200 characters, so error
  /// states (`ListView` / `DetailView`) surface what the server actually said.
  public var errorDescription: String? {
    let trimmed = body.trimmingCharacters(in: .whitespacesAndNewlines)
    let snippet = trimmed.count > 200 ? "\(trimmed.prefix(200))…" : trimmed
    return snippet.isEmpty ? "HTTP \(status)" : "HTTP \(status): \(snippet)"
  }
}

/// Thrown when a path cannot be resolved against the base URL into a valid URL.
public struct InvalidPathError: Error, LocalizedError {
  public let path: String

  public init(path: String) {
    self.path = path
  }

  public var errorDescription: String? {
    "Invalid request path: \(path)"
  }
}

/// REST client on URLSession async/await: base URL + relative paths, auth header
/// injection from `Global`, JSON via `Codable`. On 401 the instance `onUnauthorized`
/// policy (when set) may refresh credentials and retry once; when it is `nil`,
/// `Global.onUnauthorized` is invoked before the error is thrown.
public struct Http: Sendable {
  public var baseURL: URL
  public var session: URLSession
  public var decoder: JSONDecoder
  public var encoder: JSONEncoder
  /// 401 policy: return `true` after refreshing credentials to retry the request
  /// once (the retry re-reads `Global.authToken`), `false` to fail immediately.
  /// Called on the requesting task, off the main actor — hop to `@MainActor`
  /// inside if UI work is needed. When `nil`, `Global.onUnauthorized` fires instead.
  public var onUnauthorized: (@Sendable () async -> Bool)?

  public init(
    baseURL: URL,
    session: URLSession = .shared,
    decoder: JSONDecoder = JSONDecoder(),
    encoder: JSONEncoder = JSONEncoder(),
    onUnauthorized: (@Sendable () async -> Bool)? = nil
  ) {
    self.baseURL = baseURL
    self.session = session
    self.decoder = decoder
    self.encoder = encoder
    self.onUnauthorized = onUnauthorized
  }

  public func get<T: Decodable>(_ path: String) async throws -> T {
    try await request("GET", path, body: nil)
  }

  public func post<T: Decodable>(_ path: String) async throws -> T {
    try await request("POST", path, body: nil)
  }

  public func post<T: Decodable>(_ path: String, body: some Encodable) async throws -> T {
    try await request("POST", path, body: try encoder.encode(body))
  }

  public func put<T: Decodable>(_ path: String) async throws -> T {
    try await request("PUT", path, body: nil)
  }

  public func put<T: Decodable>(_ path: String, body: some Encodable) async throws -> T {
    try await request("PUT", path, body: try encoder.encode(body))
  }

  public func delete<T: Decodable>(_ path: String) async throws -> T {
    try await request("DELETE", path, body: nil)
  }

  /// POST with an ignored (possibly empty) response body.
  public func post(_ path: String) async throws {
    _ = try await send("POST", path, body: nil)
  }

  /// POST with an ignored (possibly empty) response body.
  public func post(_ path: String, body: some Encodable) async throws {
    _ = try await send("POST", path, body: try encoder.encode(body))
  }

  private func request<T: Decodable>(_ method: String, _ path: String, body: Data?) async throws
    -> T
  {
    try decoder.decode(T.self, from: try await send(method, path, body: body))
  }

  private func send(
    _ method: String, _ path: String, body: Data?, isRetry: Bool = false
  ) async throws -> Data {
    // Relative resolution keeps the query string intact; like Retrofit, the base URL
    // should end with "/" for its own path segments to be preserved.
    guard let url = URL(string: path, relativeTo: baseURL) else {
      throw InvalidPathError(path: path)
    }
    var request = URLRequest(url: url)
    request.httpMethod = method
    if !Global.authToken.isEmpty {
      request.setValue(
        "\(Global.authPrefix) \(Global.authToken)".trimmingCharacters(in: .whitespaces),
        forHTTPHeaderField: Global.authHeader)
    }
    if let body {
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.httpBody = body
    }
    let (data, response) = try await session.data(for: request)
    guard let http = response as? HTTPURLResponse else {
      throw URLError(.badServerResponse)
    }
    let status = http.statusCode
    guard (200..<300).contains(status) else {
      if status == 401, !isRetry {
        if let onUnauthorized {
          if await onUnauthorized() {
            return try await send(method, path, body: body, isRetry: true)
          }
        } else {
          Global.onUnauthorized()
        }
      }
      throw HttpError(status: status, body: String(decoding: data, as: UTF8.self))
    }
    return data
  }
}
