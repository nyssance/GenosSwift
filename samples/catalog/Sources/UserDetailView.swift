// SPDX-FileCopyrightText: 2020-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Genos
import SwiftUI

struct UserDetailView: View {
  let id: Int

  var body: some View {
    DetailView(title: "User") {
      try await Api.user(id: id)
    } content: { user in
      List {
        AsyncImage(url: URL(string: user.image)) { image in
          image.resizable().scaledToFit()
        } placeholder: {
          ProgressView()
        }
        .frame(maxWidth: .infinity)
        .listRowBackground(Color.clear)
        LabeledContent("Name", value: "\(user.firstName) \(user.lastName)")
        LabeledContent("Username", value: user.username)
        LabeledContent("Email", value: user.email)
      }
    }
  }
}
