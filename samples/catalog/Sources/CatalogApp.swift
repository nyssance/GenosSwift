// SPDX-FileCopyrightText: 2020-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Foundation
import Genos
import SwiftUI

@main
struct CatalogApp: App {
  init() {
    Global.appScheme = "genos-catalog"
    Router.route("users") { _ in Users() }
    Router.route("users/{id}") { UserDetail(id: Int($0["id"]!)!) }
  }

  var body: some Scene {
    WindowGroup {
      GenosApp(
        deepLink: ProcessInfo.processInfo.environment["OPEN_URL"].flatMap { URL(string: $0) }
          .flatMap(Router.resolve)
      ) {
        CatalogRoot()
      }
    }
  }
}

/// Destination registrations live here so list rows and details share one
/// zoom-transition namespace (iOS 18+ shared element).
struct CatalogRoot: View {
  @Namespace private var zoom

  var body: some View {
    HomeView()
      .navigationDestination(for: Users.self) { _ in UserListView(zoom: zoom) }
      .navigationDestination(for: UserDetail.self) { key in
        UserDetailView(id: key.id)
          .navigationTransition(.zoom(sourceID: key.id, in: zoom))
      }
      .navigationDestination(for: MarkdownDemo.self) { _ in MarkdownDemoView() }
  }
}
