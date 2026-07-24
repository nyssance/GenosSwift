// SPDX-FileCopyrightText: 2018-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Foundation

/// Global configuration, the same vocabulary as Genos for Android.
/// Written once at startup, read anywhere.
public enum Global {
  /// The URL scheme deep links use, e.g. `genos-sample`.
  public nonisolated(unsafe) static var appScheme = ""
  /// Sent as `Authorization: Bearer <token>` on every request when not empty.
  public nonisolated(unsafe) static var authToken = ""
  public nonisolated(unsafe) static var authHeader = "Authorization"
  public nonisolated(unsafe) static var authPrefix = "Bearer"
  /// First page number of list endpoints.
  public nonisolated(unsafe) static var listStartPage = 1
  public nonisolated(unsafe) static var listPageSize = 20
  /// Invoked on any HTTP 401 — hook the sign-in flow here.
  public nonisolated(unsafe) static var onUnauthorized: () -> Void = {}
}
