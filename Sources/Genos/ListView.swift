// SPDX-FileCopyrightText: 2018-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

/// A REST list screen: give it the endpoint and how to render one row.
/// Pull-to-refresh, page-append, loading, failure and empty are all handled here.
public struct ListView<Item: Identifiable, Row: View>: View {
  private let title: String
  private let onOpenItem: ((Item) -> Void)?
  private let row: (Item) -> Row

  @State private var pager: Pager<Item>

  public init(
    title: String,
    load: @escaping (Int) async throws -> [Item],
    onOpenItem: ((Item) -> Void)? = nil,
    @ViewBuilder row: @escaping (Item) -> Row
  ) {
    self.title = title
    self.onOpenItem = onOpenItem
    self.row = row
    _pager = State(initialValue: Pager(load))
  }

  public var body: some View {
    Group {
      switch pager.refreshState {
      case .loading:
        ProgressView()
      case .error(let error):
        ContentUnavailableView {
          Label {
            Text("Load failed", bundle: .module)
          } icon: {
            Image(systemName: "exclamationmark.triangle")
          }
        } description: {
          Text(error.localizedDescription)
        } actions: {
          Button {
            Task { await pager.refresh() }
          } label: {
            Text("Retry", bundle: .module)
          }
        }
      case .success:
        List {
          ForEach(pager.items) { item in
            Group {
              if let onOpenItem {
                Button {
                  onOpenItem(item)
                } label: {
                  row(item)
                }
                .buttonStyle(.plain)
              } else {
                row(item)
              }
            }
            .task {
              if item.id == pager.items.last?.id { await pager.loadMore() }
            }
          }
          if case .loading = pager.appendState {
            ProgressView().frame(maxWidth: .infinity)
          }
          if case .error = pager.appendState {
            Button {
              Task { await pager.loadMore() }
            } label: {
              Text("Retry", bundle: .module)
            }
            .frame(maxWidth: .infinity)
          }
        }
        .refreshable { await pager.refresh() }
      }
    }
    .navigationTitle(title)
    .task { await pager.refresh() }
  }
}
