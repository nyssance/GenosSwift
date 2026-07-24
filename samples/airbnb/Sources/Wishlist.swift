// SPDX-FileCopyrightText: 2020-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

/// Saved stay ids on AppStorage (the DataStore of the Android sample).
@MainActor
@Observable
final class Wishlist {
  static let shared = Wishlist()

  private(set) var ids: Set<Int>

  init() {
    let stored = UserDefaults.standard.string(forKey: "wishlist") ?? ""
    ids = Set(stored.split(separator: ",").compactMap { Int($0) })
  }

  func contains(_ id: Int) -> Bool {
    ids.contains(id)
  }

  func toggle(_ id: Int) {
    if !ids.insert(id).inserted { ids.remove(id) }
    UserDefaults.standard.set(ids.map(String.init).joined(separator: ","), forKey: "wishlist")
  }
}
