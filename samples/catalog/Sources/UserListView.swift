// SPDX-FileCopyrightText: 2020-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Genos
import SwiftUI

struct UserListView: View {
  let zoom: Namespace.ID

  @Environment(\.navigate) private var navigate

  var body: some View {
    ListView(title: "Users", load: Api.users) { user in
      navigate(UserDetail(id: user.id))
    } row: { user in
      HStack(spacing: 12) {
        AsyncImage(url: URL(string: user.image)) { image in
          image.resizable().scaledToFill()
        } placeholder: {
          Color.clear
        }
        .frame(width: 40, height: 40)
        .clipShape(Circle())
        VStack(alignment: .leading) {
          Text("\(user.firstName) \(user.lastName)")
          Text("@\(user.username)").font(.footnote).foregroundStyle(.secondary)
        }
      }
      .matchedTransitionSource(id: user.id, in: zoom)
    }
  }
}
