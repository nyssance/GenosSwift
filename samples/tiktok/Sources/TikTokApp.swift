// SPDX-FileCopyrightText: 2020-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

@main
struct TikTokApp: App {
  var body: some Scene {
    WindowGroup {
      ForYouView()
        .preferredColorScheme(.dark)
    }
  }
}
