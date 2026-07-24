// SPDX-FileCopyrightText: 2018-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Highlightr
import MarkdownUI
import SwiftUI
import UIKit

/// Markdown rendering with syntax-highlighted code blocks, the `MarkdownText` of
/// Genos for Android: full GFM (headings, lists, code blocks, tables) on MarkdownUI,
/// highlighting on Highlightr. Style with MarkdownUI's `.markdownTheme` as needed.
public struct MarkdownText: View {
  private let markdown: String

  @Environment(\.colorScheme) private var colorScheme

  public init(_ markdown: String) {
    self.markdown = markdown
  }

  public var body: some View {
    Markdown(markdown)
      .markdownCodeSyntaxHighlighter(CodeHighlighter(dark: colorScheme == .dark))
  }
}

/// Highlightr instances are heavy (JSCore + highlight.js): one per appearance,
/// cached for the process. Main-thread only (SwiftUI renders code blocks there).
private final class HighlighterCache {
  nonisolated(unsafe) static let shared = HighlighterCache()
  let light: Highlightr?
  let dark: Highlightr?

  init() {
    let font = UIFont.monospacedSystemFont(ofSize: 13, weight: .regular)
    light = Highlightr()
    light?.setTheme(to: "xcode")
    light?.theme.setCodeFont(font)
    dark = Highlightr()
    dark?.setTheme(to: "atom-one-dark")
    dark?.theme.setCodeFont(font)
  }
}

/// Code-block highlighter for MarkdownUI, reusable by applications that bring their
/// own markdown theme. Unknown language / failure falls back to plain text.
public struct CodeHighlighter: CodeSyntaxHighlighter {
  let dark: Bool

  public init(dark: Bool) {
    self.dark = dark
  }

  public func highlightCode(_ code: String, language: String?) -> Text {
    let highlightr = dark ? HighlighterCache.shared.dark : HighlighterCache.shared.light
    // Trim trailing newlines so code blocks do not end with an empty line
    var source = code
    while source.hasSuffix("\n") { source.removeLast() }
    guard let attributed = highlightr?.highlight(source, as: language, fastRender: true) else {
      return Text(source)
    }
    return Text(AttributedString(attributed))
  }
}
