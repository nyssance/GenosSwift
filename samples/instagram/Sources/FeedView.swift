// SPDX-FileCopyrightText: 2020-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Genos
import SwiftUI

struct FeedView: View {
  @Environment(\.navigate) private var navigate
  @State private var posts = Pager(Api.posts)
  @State private var users: [User] = []

  private var usersById: [Int: User] {
    Dictionary(uniqueKeysWithValues: users.map { ($0.id, $0) })
  }

  var body: some View {
    List {
      stories
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
      ForEach(posts.items) { post in
        PostCard(post: post, author: usersById[post.userId]) {
          navigate(PostDetail(id: post.id))
        }
        .listRowInsets(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0))
        .listRowSeparator(.hidden)
        .task {
          if post.id == posts.items.last?.id { await posts.loadMore() }
        }
      }
    }
    .listStyle(.plain)
    .navigationTitle("Feed")
    .task {
      await posts.refresh()
      users = (try? await Api.users()) ?? []
    }
    .refreshable { await posts.refresh() }
  }

  private var stories: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 16) {
        ForEach(users.prefix(12)) { user in
          VStack(spacing: 4) {
            AsyncImage(url: URL(string: user.image)) { image in
              image.resizable().scaledToFill()
            } placeholder: {
              Color(.systemGray6)
            }
            .frame(width: 56, height: 56)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color(.systemGray4), lineWidth: 2))
            Text(user.username)
              .font(.caption2)
              .lineLimit(1)
          }
          .frame(width: 64)
        }
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 8)
    }
  }
}

struct PostCard: View {
  let post: Post
  let author: User?
  let onOpen: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack(spacing: 8) {
        AsyncImage(url: URL(string: author?.image ?? "")) { image in
          image.resizable().scaledToFill()
        } placeholder: {
          Color(.systemGray6)
        }
        .frame(width: 32, height: 32)
        .clipShape(Circle())
        Text(author?.username ?? "user\(post.userId)")
          .font(.subheadline.weight(.semibold))
      }
      .padding(.horizontal, 12)
      Button(action: onOpen) {
        AsyncImage(url: URL(string: post.image)) { image in
          image.resizable().scaledToFill()
        } placeholder: {
          Color(.systemGray6)
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .clipped()
      }
      .buttonStyle(.plain)
      HStack(spacing: 16) {
        Image(systemName: "heart")
        Image(systemName: "bubble.right")
        Image(systemName: "paperplane")
        Spacer()
        Image(systemName: "bookmark")
      }
      .font(.system(size: 20))
      .padding(.horizontal, 12)
      Text("\(post.reactions.likes) likes")
        .font(.subheadline.weight(.semibold))
        .padding(.horizontal, 12)
      Text(post.title)
        .font(.subheadline)
        .lineLimit(2)
        .padding(.horizontal, 12)
    }
  }
}
