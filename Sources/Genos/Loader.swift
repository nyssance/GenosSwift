// SPDX-FileCopyrightText: 2018-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Observation

/// Detail-screen loader: one endpoint, `UiState` out, `refresh()` to reload.
@MainActor
@Observable
public final class Loader<T> {
  public private(set) var uiState: UiState<T> = .loading

  private let load: () async throws -> T

  public init(_ load: @escaping () async throws -> T) {
    self.load = load
  }

  public func refresh() async {
    do {
      uiState = .success(try await load())
    } catch {
      uiState = .error(error)
    }
  }
}
