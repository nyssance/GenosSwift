// SPDX-FileCopyrightText: 2020-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Genos
import SwiftUI

struct PostDetailView: View {
  let id: Int

  var body: some View {
    DetailView(title: "Post") {
      async let post = Api.post(id: id)
      async let comments = Api.commentsOfPost(id)
      return try await (post: post, comments: comments)
    } content: { data in
      ScrollView {
        VStack(alignment: .leading, spacing: 12) {
          AsyncImage(url: URL(string: data.post.image)) { image in
            image.resizable().scaledToFill()
          } placeholder: {
            Color(.systemGray6)
          }
          .frame(maxWidth: .infinity)
          .aspectRatio(1, contentMode: .fit)
          .clipped()
          Group {
            Text("\(data.post.reactions.likes) likes")
              .font(.subheadline.weight(.semibold))
            Text(data.post.body)
              .font(.subheadline)
            Text(data.post.tags.map { "#\($0)" }.joined(separator: " "))
              .font(.subheadline)
              .foregroundStyle(.secondary)
            Divider()
            Text("Comments").font(.headline)
            ForEach(data.comments) { comment in
              VStack(alignment: .leading, spacing: 2) {
                Text(comment.user.username).font(.subheadline.weight(.semibold))
                Text(comment.body).font(.subheadline)
              }
            }
          }
          .padding(.horizontal, 12)
        }
      }
    }
  }
}
