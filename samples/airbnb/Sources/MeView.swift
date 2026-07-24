// SPDX-FileCopyrightText: 2020-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Genos
import SwiftUI

private let http = Http(baseURL: URL(string: "https://dummyjson.com/")!)

private struct User: Codable {
  let firstName: String
  let lastName: String
  let username: String
  let image: String
}

struct MeView: View {
  var body: some View {
    DetailView(title: "Me") {
      try await http.get("users/1") as User
    } content: { user in
      List {
        HStack(spacing: 16) {
          AsyncImage(url: URL(string: user.image)) { image in
            image.resizable().scaledToFill()
          } placeholder: {
            Color(.systemGray5)
          }
          .frame(width: 64, height: 64)
          .clipShape(Circle())
          VStack(alignment: .leading, spacing: 2) {
            Text("\(user.firstName) \(user.lastName)").font(.title3.bold())
            Text("@\(user.username)").font(.subheadline).foregroundStyle(.secondary)
          }
        }
        Section("Settings") {
          Toggle("Notifications", isOn: .constant(true))
        }
      }
    }
  }
}
