// SPDX-FileCopyrightText: 2020-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Genos
import SwiftUI

struct StayDetail: NavKey {
  let id: Int
}

@main
struct AirbnbApp: App {
  init() {
    Global.appScheme = "genos-airbnb"
    Router.route("stays/{id}") { StayDetail(id: Int($0["id"]!)!) }
  }

  var body: some Scene {
    WindowGroup {
      GenosApp(tabs: [
        GenosTab("Explore", systemImage: "magnifyingglass") {
          ExploreView()
            .navigationDestination(for: StayDetail.self) { StayDetailView(id: $0.id) }
        },
        GenosTab("Wishlists", systemImage: "heart") {
          WishlistsView()
            .navigationDestination(for: StayDetail.self) { StayDetailView(id: $0.id) }
        },
        GenosTab("Me", systemImage: "person.circle") { MeView() },
      ])
      // Brand palette: coral, the Android sample's Theme override.
      .tint(Color(red: 1, green: 0.22, blue: 0.36))
    }
  }
}
