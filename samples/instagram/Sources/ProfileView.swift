// SPDX-FileCopyrightText: 2020-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Genos
import SwiftUI

private let myUserId = 5

struct ProfileView: View {
  @Environment(\.navigate) private var navigate

  private let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 3)

  var body: some View {
    DetailView(title: "Profile") {
      async let user: User = http.get("users/\(myUserId)")
      async let posts = Api.postsOfUser(myUserId)
      return try await (user: user, posts: posts)
    } content: { data in
      ScrollView {
        VStack(spacing: 16) {
          HStack(spacing: 24) {
            AsyncImage(url: URL(string: data.user.image)) { image in
              image.resizable().scaledToFill()
            } placeholder: {
              Color(.systemGray6)
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            stat("\(data.posts.count)", "Posts")
            stat("2.1k", "Followers")
            stat("312", "Following")
          }
          .padding(.horizontal, 16)
          .frame(maxWidth: .infinity, alignment: .leading)
          VStack(alignment: .leading, spacing: 2) {
            Text("\(data.user.firstName) \(data.user.lastName)")
              .font(.subheadline.weight(.semibold))
            Text("@\(data.user.username)")
              .font(.subheadline)
              .foregroundStyle(.secondary)
          }
          .padding(.horizontal, 16)
          .frame(maxWidth: .infinity, alignment: .leading)
          LazyVGrid(columns: columns, spacing: 2) {
            ForEach(data.posts) { post in
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
            }
          }
        }
      }
    }
  }

  private func stat(_ value: String, _ label: String) -> some View {
    VStack {
      Text(value).font(.headline)
      Text(label).font(.caption)
    }
  }
}
