// SPDX-FileCopyrightText: 2018-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Foundation
import Synchronization

/// Global configuration, the same vocabulary as Genos for Android.
/// Written once at startup, read anywhere: every field is safe to access from any
/// thread — the main actor writes them, `Http` reads them off the main actor — so
/// the storage sits behind a `Mutex`.
public enum Global {
  private struct Storage: Sendable {
    var appScheme = ""
    var authToken = ""
    var authHeader = "Authorization"
    var authPrefix = "Bearer"
    var listStartPage = 1
    var listPageSize = 20
    var onUnauthorized: @Sendable () -> Void = {}
  }

  private static let storage = Mutex(Storage())

  /// The URL scheme deep links use, e.g. `genos-sample`.
  public static var appScheme: String {
    get { storage.withLock { $0.appScheme } }
    set { storage.withLock { $0.appScheme = newValue } }
  }

  /// Sent as `Authorization: Bearer <token>` on every request when not empty.
  public static var authToken: String {
    get { storage.withLock { $0.authToken } }
    set { storage.withLock { $0.authToken = newValue } }
  }

  public static var authHeader: String {
    get { storage.withLock { $0.authHeader } }
    set { storage.withLock { $0.authHeader = newValue } }
  }

  public static var authPrefix: String {
    get { storage.withLock { $0.authPrefix } }
    set { storage.withLock { $0.authPrefix = newValue } }
  }

  /// First page number of list endpoints.
  public static var listStartPage: Int {
    get { storage.withLock { $0.listStartPage } }
    set { storage.withLock { $0.listStartPage = newValue } }
  }

  public static var listPageSize: Int {
    get { storage.withLock { $0.listPageSize } }
    set { storage.withLock { $0.listPageSize = newValue } }
  }

  /// Invoked on an HTTP 401 when the `Http` instance has no `onUnauthorized`
  /// policy of its own — hook the sign-in flow here. Called on the requesting
  /// task, off the main actor.
  public static var onUnauthorized: @Sendable () -> Void {
    get { storage.withLock { $0.onUnauthorized } }
    set { storage.withLock { $0.onUnauthorized = newValue } }
  }
}
