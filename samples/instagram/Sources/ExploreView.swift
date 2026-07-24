// SPDX-FileCopyrightText: 2020-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Genos
import SwiftUI

struct ExploreView: View {
  @Environment(\.navigate) private var navigate
  @State private var posts = Pager(Api.posts)

  private let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 3)

  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns, spacing: 2) {
        ForEach(posts.items) { post in
          Button {
            navigate(PostDetail(id: post.id))
          } label: {
            AsyncImage(url: URL(string: post.image)) { image in
              image.resizable().scaledToFill()
            } placeholder: {
              Color(.systemGray6)
            }
            .aspectRatio(1, contentMode: .fill)
            .clipped()
          }
          .buttonStyle(.plain)
          .task {
            if post.id == posts.items.last?.id { await posts.loadMore() }
          }
        }
      }
    }
    .navigationTitle("Explore")
    .task { await posts.refresh() }
    .refreshable { await posts.refresh() }
  }
}
