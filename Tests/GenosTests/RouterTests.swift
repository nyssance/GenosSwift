// SPDX-FileCopyrightText: 2018-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Foundation
import Testing

@testable import Genos

private struct Users: NavKey {}

private struct UserDetail: NavKey {
  let username: String
}

private struct Comment: NavKey {
  let postId: String
  let commentId: String
}

@Suite(.serialized)
struct RouterTests {
  init() {
    Global.appScheme = "genos-test"
    Router.reset()
    Router.route("users") { _ in Users() }
    Router.route("users/{username}") { UserDetail(username: $0["username"]!) }
    Router.route("posts/{postId}/comments/{commentId}") {
      Comment(postId: $0["postId"]!, commentId: $0["commentId"]!)
    }
  }

  @Test func staticRouteMatches() {
    #expect(Router.resolve(URL(string: "genos-test://users")!) as? Users == Users())
  }

  @Test func parameterIsExtracted() {
    #expect(
      Router.resolve(URL(string: "genos-test://users/emilys")!) as? UserDetail
        == UserDetail(username: "emilys"))
  }

  @Test func multipleParametersAreExtracted() {
    #expect(
      Router.resolve(URL(string: "genos-test://posts/7/comments/42")!) as? Comment
        == Comment(postId: "7", commentId: "42"))
  }

  @Test func wrongSchemeResolvesToNothing() {
    #expect(Router.resolve(URL(string: "other-scheme://users")!) == nil)
  }

  @Test func unknownPathResolvesToNothing() {
    #expect(Router.resolve(URL(string: "genos-test://stays")!) == nil)
  }

  @Test func segmentCountMustMatch() {
    #expect(Router.resolve(URL(string: "genos-test://users/emilys/followers")!) == nil)
  }
}
