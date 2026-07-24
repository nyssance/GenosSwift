// SPDX-FileCopyrightText: 2020-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Genos
import SwiftUI

struct HomeView: View {
  @Environment(\.navigate) private var navigate

  var body: some View {
    List {
      Section("Components") {
        Button("User list") { navigate(Users()) }
        Button("Markdown") { navigate(MarkdownDemo()) }
      }
    }
    .navigationTitle("Genos Catalog")
  }
}
