// SPDX-FileCopyrightText: 2018-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

/// A REST detail screen: give it the endpoint and how to render the data.
public struct DetailView<T, Content: View>: View {
  private let title: String
  private let content: (T) -> Content

  @State private var loader: Loader<T>

  public init(
    title: String,
    load: @escaping () async throws -> T,
    @ViewBuilder content: @escaping (T) -> Content
  ) {
    self.title = title
    self.content = content
    _loader = State(initialValue: Loader(load))
  }

  public var body: some View {
    Group {
      switch loader.uiState {
      case .loading:
        ProgressView()
      case .error(let error):
        ContentUnavailableView {
          Label("Load failed", systemImage: "exclamationmark.triangle")
        } description: {
          Text(error.localizedDescription)
        } actions: {
          Button("Retry") {
            Task { await loader.refresh() }
          }
        }
      case .success(let data):
        content(data)
      }
    }
    .navigationTitle(title)
    .navigationBarTitleDisplayMode(.inline)
    .task { await loader.refresh() }
  }
}
