// SPDX-FileCopyrightText: 2018-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Testing

@testable import Genos

@MainActor
struct LoaderTests {
  @Test func refreshSucceeds() async {
    let loader = Loader { "data" }
    await loader.refresh()
    guard case .success(let value) = loader.uiState else {
      Issue.record("expected success state")
      return
    }
    #expect(value == "data")
  }

  @Test func failureBecomesErrorState() async {
    struct Failure: Error {}
    let loader = Loader<String> { throw Failure() }
    await loader.refresh()
    guard case .error = loader.uiState else {
      Issue.record("expected error state")
      return
    }
  }
}
