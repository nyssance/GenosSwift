// SPDX-FileCopyrightText: 2018-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Observation

/// Page-number paginator for REST list endpoints, the `PageSource` of Genos for
/// Android: the application only provides `(page) -> [Item]`.
@MainActor
@Observable
public final class Pager<Item> {
  public private(set) var items: [Item] = []
  /// State of the initial load / pull-to-refresh.
  public private(set) var refreshState: UiState<Void> = .loading
  /// Non-nil while a next page is loading or has failed.
  public private(set) var appendState: UiState<Void>?
  public private(set) var exhausted = false

  private var nextPage = Global.listStartPage
  private let load: (Int) async throws -> [Item]

  public init(_ load: @escaping (Int) async throws -> [Item]) {
    self.load = load
  }

  public func refresh() async {
    if items.isEmpty { refreshState = .loading }
    do {
      let page = try await load(Global.listStartPage)
      items = page
      nextPage = Global.listStartPage + 1
      exhausted = page.isEmpty
      refreshState = .success(())
      appendState = nil
    } catch {
      refreshState = .error(error)
    }
  }

  public func loadMore() async {
    guard !exhausted, appendState == nil || isAppendError else { return }
    appendState = .loading
    do {
      let page = try await load(nextPage)
      items += page
      nextPage += 1
      exhausted = page.isEmpty
      appendState = nil
    } catch {
      appendState = .error(error)
    }
  }

  private var isAppendError: Bool {
    if case .error = appendState { true } else { false }
  }
}
