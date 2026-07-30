// SPDX-FileCopyrightText: 2018-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Foundation
import os

/// A navigation key: a plain value the application owns.
/// Screens, deep links and REST endpoints share one vocabulary:
/// `UserDetail(username)` ↔ `genos-sample://users/{username}` ↔ `GET /users/{username}`.
public protocol NavKey: Hashable, Codable {}

/// Deep link routing: URL ↔ NavKey, convention based, same as Genos for Android.
public enum Router {
  private struct Route: Sendable {
    let segments: [String]
    let create: @Sendable ([String: String]) -> any NavKey
  }

  // OSAllocatedUnfairLock rather than Mutex: see the note on `Global.storage`.
  private static let routes = OSAllocatedUnfairLock(initialState: [Route]())

  public static func route(
    _ pattern: String, create: @escaping @Sendable ([String: String]) -> any NavKey
  ) {
    let route = Route(
      segments: pattern.split(separator: "/").map(String.init), create: create)
    routes.withLock { $0.append(route) }
  }

  /// Resolves a deep link URL against the registered routes. Query items are merged
  /// into the parameters passed to `create`; on a name clash the path parameter wins.
  public static func resolve(_ url: URL) -> (any NavKey)? {
    guard url.scheme == Global.appScheme else { return nil }
    let segments = [url.host()].compactMap(\.self) + url.pathComponents.dropFirst()
    var query: [String: String] = [:]
    for item in URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? [] {
      query[item.name] = item.value ?? ""
    }
    let candidates = routes.withLock { $0 }
    for route in candidates where route.segments.count == segments.count {
      var parameters = query
      var matched = true
      for (expected, actual) in zip(route.segments, segments) {
        if expected.hasPrefix("{"), expected.hasSuffix("}") {
          parameters[String(expected.dropFirst().dropLast())] = actual
        } else if expected != actual {
          matched = false
          break
        }
      }
      if matched { return route.create(parameters) }
    }
    return nil
  }

  /// Test support: clears all registered routes.
  static func reset() {
    routes.withLock { $0.removeAll() }
  }
}
