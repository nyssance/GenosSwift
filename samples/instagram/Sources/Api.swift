// SPDX-FileCopyrightText: 2020-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Foundation
import Genos

let http = Http(baseURL: URL(string: "https://dummyjson.com/")!)

struct Post: Codable, Identifiable {
  let id: Int
  let title: String
  let body: String
  let tags: [String]
  let reactions: Reactions
  let userId: Int

  /// Square feed image, seeded per post (the Android sample's picsum convention).
  var image: String { "https://picsum.photos/seed/post\(id)/900/900" }
}

struct Reactions: Codable {
  let likes: Int
  let dislikes: Int
}

struct PostsPage: Codable {
  let posts: [Post]
}

struct User: Codable, Identifiable {
  let id: Int
  let firstName: String
  let lastName: String
  let username: String
  let image: String
}

struct UsersPage: Codable {
  let users: [User]
}

struct Comment: Codable, Identifiable {
  let id: Int
  let body: String
  let user: CommentUser
}

struct CommentUser: Codable {
  let username: String
}

struct CommentsPage: Codable {
  let comments: [Comment]
}

enum Api {
  static func posts(page: Int) async throws -> [Post] {
    let skip = (page - Global.listStartPage) * Global.listPageSize
    let result: PostsPage = try await http.get("posts?limit=\(Global.listPageSize)&skip=\(skip)")
    return result.posts
  }

  static func post(id: Int) async throws -> Post {
    try await http.get("posts/\(id)")
  }

  static func postsOfUser(_ userId: Int) async throws -> [Post] {
    let result: PostsPage = try await http.get("posts/user/\(userId)")
    return result.posts
  }

  static func commentsOfPost(_ postId: Int) async throws -> [Comment] {
    let result: CommentsPage = try await http.get("comments/post/\(postId)")
    return result.comments
  }

  static func users() async throws -> [User] {
    let result: UsersPage = try await http.get("users?limit=0")
    return result.users
  }
}
