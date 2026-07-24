// SPDX-FileCopyrightText: 2018-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Testing

@testable import Genos

@MainActor
struct PagerTests {
  @Test func refreshLoadsTheFirstPage() async {
    let pager = Pager { page in ["item of page \(page)"] }
    await pager.refresh()
    #expect(pager.items == ["item of page \(Global.listStartPage)"])
    #expect(!pager.exhausted)
  }

  @Test func loadMoreAppendsTheNextPage() async {
    let pager = Pager { page in ["page \(page)"] }
    await pager.refresh()
    await pager.loadMore()
    #expect(pager.items == ["page \(Global.listStartPage)", "page \(Global.listStartPage + 1)"])
  }

  @Test func emptyPageEndsPaging() async {
    let pager = Pager { _ in [String]() }
    await pager.refresh()
    #expect(pager.exhausted)
    await pager.loadMore()
    #expect(pager.items.isEmpty)
  }

  @Test func failureBecomesErrorState() async {
    struct Failure: Error {}
    let pager = Pager<String> { _ in throw Failure() }
    await pager.refresh()
    guard case .error = pager.refreshState else {
      Issue.record("expected error state")
      return
    }
  }
}
