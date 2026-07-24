// SPDX-FileCopyrightText: 2020-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Genos
import SwiftUI

private let sample = """
  # Genos Markdown

  Full **GFM** on MarkdownUI with *syntax highlighted* code blocks:

  ```swift
  struct UserDetail: NavKey {
    let id: Int
  }
  ```

  - Headings, lists and tables
  - `inline code`
  - [Links](https://developer.apple.com)
  """

struct MarkdownDemoView: View {
  var body: some View {
    ScrollView {
      MarkdownText(sample)
        .padding()
    }
    .navigationTitle("Markdown")
  }
}
