// SPDX-FileCopyrightText: 2018-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct HttpError: Error {
  public let status: Int
  public let body: String

  public init(status: Int, body: String) {
    self.status = status
    self.body = body
  }
}

/// REST client on URLSession async/await: base URL + relative paths, auth header
/// injection from `Global`, JSON via `Codable`. Any 401 invokes `Global.onUnauthorized`.
public struct Http: Sendable {
  public var baseURL: URL
  public var decoder: JSONDecoder
  public var encoder: JSONEncoder

  public init(
    baseURL: URL,
    decoder: JSONDecoder = JSONDecoder(),
    encoder: JSONEncoder = JSONEncoder()
  ) {
    self.baseURL = baseURL
    self.decoder = decoder
    self.encoder = encoder
  }

  public func get<T: Decodable>(_ path: String) async throws -> T {
    try await request("GET", path)
  }

  public func post<T: Decodable>(_ path: String, body: (some Encodable)? = nil as Int?) async throws
    -> T
  {
    try await request("POST", path, body: body)
  }

  public func put<T: Decodable>(_ path: String, body: (some Encodable)? = nil as Int?) async throws
    -> T
  {
    try await request("PUT", path, body: body)
  }

  public func delete<T: Decodable>(_ path: String) async throws -> T {
    try await request("DELETE", path)
  }

  /// POST with an ignored (possibly empty) response body.
  public func post(_ path: String, body: (some Encodable)? = nil as Int?) async throws {
    _ = try await send("POST", path, body: body)
  }

  private func request<T: Decodable>(
    _ method: String, _ path: String, body: (some Encodable)? = nil as Int?
  ) async throws -> T {
    try decoder.decode(T.self, from: try await send(method, path, body: body))
  }

  private func send(
    _ method: String, _ path: String, body: (some Encodable)? = nil as Int?
  ) async throws -> Data {
    // Relative resolution keeps the query string intact; like Retrofit, the base URL
    // should end with "/" for its own path segments to be preserved.
    var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
    request.httpMethod = method
    if !Global.authToken.isEmpty {
      request.setValue(
        "\(Global.authPrefix) \(Global.authToken)".trimmingCharacters(in: .whitespaces),
        forHTTPHeaderField: Global.authHeader)
    }
    if let body {
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.httpBody = try encoder.encode(body)
    }
    let (data, response) = try await URLSession.shared.data(for: request)
    let status = (response as! HTTPURLResponse).statusCode
    guard (200..<300).contains(status) else {
      if status == 401 { Global.onUnauthorized() }
      throw HttpError(status: status, body: String(decoding: data, as: UTF8.self))
    }
    return data
  }
}
