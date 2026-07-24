// SPDX-FileCopyrightText: 2020-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Genos
import SwiftUI

struct PostDetail: NavKey {
  let id: Int
}

@main
struct InstagramApp: App {
  init() {
    Global.appScheme = "genos-instagram"
    Router.route("posts/{id}") { PostDetail(id: Int($0["id"]!)!) }
  }

  var body: some Scene {
    WindowGroup {
      GenosApp(tabs: [
        GenosTab("Feed", systemImage: "house") {
          FeedView()
            .navigationDestination(for: PostDetail.self) { PostDetailView(id: $0.id) }
        },
        GenosTab("Explore", systemImage: "magnifyingglass") {
          ExploreView()
            .navigationDestination(for: PostDetail.self) { PostDetailView(id: $0.id) }
        },
        GenosTab("Profile", systemImage: "person.crop.circle") {
          ProfileView()
            .navigationDestination(for: PostDetail.self) { PostDetailView(id: $0.id) }
        },
      ])
      // Monochrome brand: Instagram's black-on-white chrome.
      .tint(.primary)
    }
  }
}
