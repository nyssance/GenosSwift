// SPDX-FileCopyrightText: 2020-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Foundation
import Genos

let http = Http(baseURL: URL(string: "https://dummyjson.com/")!)

struct User: Codable, Identifiable {
  let id: Int
  let firstName: String
  let lastName: String
  let username: String
  let email: String
  let image: String
}

struct UsersPage: Codable {
  let users: [User]
}

enum Api {
  static func users(page: Int) async throws -> [User] {
    let skip = (page - Global.listStartPage) * Global.listPageSize
    let result: UsersPage = try await http.get("users?limit=\(Global.listPageSize)&skip=\(skip)")
    return result.users
  }

  static func user(id: Int) async throws -> User {
    try await http.get("users/\(id)")
  }
}
