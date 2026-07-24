// SPDX-FileCopyrightText: 2018-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Foundation

/// A navigation key: a plain value the application owns.
/// Screens, deep links and REST endpoints share one vocabulary:
/// `UserDetail(username)` ↔ `genos-sample://users/{username}` ↔ `GET /users/{username}`.
public protocol NavKey: Hashable, Codable {}

/// Deep link routing: URL ↔ NavKey, convention based, same as Genos for Android.
public enum Router {
  private struct Route {
    let segments: [String]
    let create: ([String: String]) -> any NavKey
  }

  private nonisolated(unsafe) static var routes: [Route] = []

  public static func route(_ pattern: String, create: @escaping ([String: String]) -> any NavKey) {
    routes.append(Route(segments: pattern.split(separator: "/").map(String.init), create: create))
  }

  public static func resolve(_ url: URL) -> (any NavKey)? {
    guard url.scheme == Global.appScheme else { return nil }
    let segments = [url.host()].compactMap(\.self) + url.pathComponents.dropFirst()
    for route in routes where route.segments.count == segments.count {
      var parameters: [String: String] = [:]
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
    routes.removeAll()
  }
}
