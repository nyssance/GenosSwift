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
  /// Bumped by every `refresh()`; a load started under an older generation is
  /// stale and its result is discarded, so an in-flight `loadMore()` cannot
  /// append an old page after a refresh reset `items`.
  private var generation = 0
  private let load: (Int) async throws -> [Item]

  public init(_ load: @escaping (Int) async throws -> [Item]) {
    self.load = load
  }

  public func refresh() async {
    generation += 1
    let current = generation
    if items.isEmpty { refreshState = .loading }
    do {
      let page = try await load(Global.listStartPage)
      guard current == generation else { return }
      items = page
      nextPage = Global.listStartPage + 1
      exhausted = page.isEmpty
      refreshState = .success(())
      appendState = nil
    } catch {
      guard current == generation else { return }
      refreshState = .error(error)
    }
  }

  public func loadMore() async {
    guard !exhausted, appendState == nil || isAppendError else { return }
    let current = generation
    appendState = .loading
    do {
      let page = try await load(nextPage)
      guard current == generation else { return }
      items += page
      nextPage += 1
      exhausted = page.isEmpty
      appendState = nil
    } catch {
      guard current == generation else { return }
      appendState = .error(error)
    }
  }

  private var isAppendError: Bool {
    if case .error = appendState { true } else { false }
  }
}
