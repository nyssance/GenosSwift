# Changelog

All notable changes to Genos for iOS are documented in this file. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versions follow
[Semantic Versioning](https://semver.org/).

## [3.0.0-alpha03] - 2026-07-30

### Fixed

- **Critical:** launch crash on device Release builds. The compiler statically
  initializes `Synchronization.Mutex` globals at compile time, and on device
  builds this zeroed out the guarded state's member defaults — `Global.authHeader`
  became an empty string, crashing CFNetwork inside
  `URLRequest.setValue(_:forHTTPHeaderField:)` on the first authenticated request
  (`listStartPage`/`listPageSize` were likewise zeroed). `Global` and `Router`
  storage now sits behind `OSAllocatedUnfairLock`, whose heap-allocated state
  cannot be constant-folded. Simulator builds were unaffected, which is why CI
  did not catch it.

## [3.0.0-alpha02] - 2026-07-30

### Added

- `Http`: `session:` injection (URLProtocol-testable) and an instance-level
  `onUnauthorized: (@Sendable () async -> Bool)?` refresh policy — return `true` after
  refreshing to retry the request once with the fresh `Global.authToken`. When the policy
  is set, 401 no longer fires `Global.onUnauthorized`.
- `HttpError` conforms to `LocalizedError` (status + truncated body); new
  `InvalidPathError` for paths that cannot form a URL.
- `GenosTab`: explicit `id:` parameter so duplicate titles stay `Identifiable`-safe.
- `UiState: Sendable` when `T: Sendable`.
- Package localization (`defaultLocalization: en`, String Catalog with zh-Hans) for the
  built-in "Load failed" / "Retry" strings.
- `Router.resolve` passes query parameters through to `create` (path parameters win on
  name collisions).
- Tests: `Http` (auth header, 401 retry policy, error mapping, body encoding), `Pager`
  stale-load, `Router` query parameters.

### Changed

- **Breaking:** `Global.onUnauthorized` and `Router.route` create closures are
  `@Sendable` (no-capture literals are unaffected).
- **Breaking:** `Http.post`/`put` explicit with/without-body overloads replace the
  `body: (some Encodable)? = nil as Int?` default-generic trick; a non-nil `Optional`
  body now encodes as its wrapped value would, and bodyless calls take the dedicated
  overload.

### Fixed

- `Global` and `Router` mutable statics are `Mutex`-guarded — the
  `nonisolated(unsafe)` data race between MainActor writers and background readers
  (e.g. `Http.send` reading `authToken`) is gone.
- `Http` no longer force-unwraps URL construction or the `HTTPURLResponse` cast.
- Cold-start deep links are buffered until navigation restore completes instead of
  being clobbered by it.
- `Pager`: results from a superseded generation (`refresh()` during an in-flight
  `loadMore()`) are discarded.

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
