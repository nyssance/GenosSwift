# Changelog

All notable changes to Genos for iOS are documented in this file. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versions follow
[Semantic Versioning](https://semver.org/).

## [3.0.0-alpha01] - 2026-07-24

### Added

- Genos 3: full rewrite on the official 2026 iOS stack, sharing the Genos 3 for Android
  vocabulary — SwiftUI, `NavigationStack(path:)` with application-owned `NavKey` values
  (one path per tab in `GenosApp`), `Router` deep links, `navigate` environment action,
  `ListView` / `DetailView` with `Pager` / `Loader`, `Http` on URLSession async/await +
  Codable with `Global.onUnauthorized` on 401, `MarkdownText`, `@Observable` state.
- `MarkdownText`: full GFM with syntax-highlighted code blocks (MarkdownUI +
  Highlightr, the pair Genos for Android exports); `CodeHighlighter` is public for
  applications bringing their own markdown theme.
- Navigation state restoration: the selected tab and every path survive process death
  (SceneStorage), the `rememberNavBackStack` guarantee of Android.
- Samples: `catalog` (list / detail / markdown / zoom transition / deep links) and
  replicas of real products — `airbnb`, `instagram`, `tiktok`.
- CI: build, tests and swift-format lint on every push and pull request.

### Removed

- **Breaking:** the entire UIKit implementation (0.2.x) and CocoaPods distribution —
  Genos 3 is a Swift Package, iOS 26+.
