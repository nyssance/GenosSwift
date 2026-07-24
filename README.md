# Genos 3 for iOS

[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](LICENSE)

👊 Genos makes it easy to build better iOS applications quickly and with less application code.

- [Genos for Android](https://github.com/nyssance/genos)

## Philosophy

A screen is a REST endpoint plus blanks to fill in. Genos provides the complete screen —
loading, failure, pull-to-refresh, paging, retry — and the application provides only the
endpoint, the item identity, the row rendering and what happens on tap.

Screens, deep links and REST endpoints share one vocabulary:
`UserDetail(username)` ↔ `genos-sample://users/{username}` ↔ `GET /users/{username}`.

## 3.0

Genos 3 keeps the original high-level framework design and replaces the UIKit
implementation with the official 2026 stack, sharing its vocabulary with Genos 3 for
Android:

- SwiftUI replaces UIKit. Swift Package Manager replaces CocoaPods.
- `NavigationStack(path:)` — the back stack is a plain list of `NavKey` values the
  application owns, exactly the Navigation 3 model on Android. One path per tab.
- `Router` resolves deep links to keys by convention; `navigate` in the environment
  pushes keys programmatically (the `backStack.add` of Android).
- `ListView` / `DetailView`: a REST screen is one view — paging (`Pager`),
  pull-to-refresh, loading, failure and retry are all framework.
- `Http`: URLSession async/await + Codable, auth header from `Global`, any 401 invokes
  `Global.onUnauthorized`.
- `@Observable` (Observation) replaces ObservableObject.

What Android Genos ships as components, iOS ships natively — so Genos does not wrap it:
collapsing large titles (`.navigationTitle`), grouped rounded lists (`.insetGrouped`),
adaptive list-detail (`NavigationSplitView`), video (`AVKit.VideoPlayer`), placeholders
(`ContentUnavailableView`).

## Installation

Swift Package Manager, iOS 26+:

```swift
.package(url: "https://github.com/nyssance/GenosSwift", from: "3.0.0-alpha01")
```

## List

```swift
struct UserListView: View {
  @Environment(\.navigate) private var navigate

  var body: some View {
    ListView(title: "Users", load: Api.users) { user in
      navigate(UserDetail(id: user.id))
    } row: { user in
      Text(user.username)
    }
  }
}
```

## Detail

```swift
struct UserDetailView: View {
  let id: Int

  var body: some View {
    DetailView(title: "User") {
      try await Api.user(id: id)
    } content: { user in
      List {
        LabeledContent("Username", value: user.username)
      }
    }
  }
}
```

## Navigation

Routes are plain value keys — the single source of truth shared by screens, deep links
and endpoints:

```swift
struct Users: NavKey {}
struct UserDetail: NavKey { let id: Int }

@main
struct SampleApp: App {
  init() {
    Global.appScheme = "genos-sample"
    Router.route("users") { _ in Users() }
    Router.route("users/{id}") { UserDetail(id: Int($0["id"]!)!) }
  }

  var body: some Scene {
    WindowGroup {
      GenosApp(tabs: [
        GenosTab("Home", systemImage: "house") {
          HomeView()
            .navigationDestination(for: Users.self) { _ in UserListView() }
            .navigationDestination(for: UserDetail.self) { UserDetailView(id: $0.id) }
        },
        GenosTab("Me", systemImage: "person.circle") { MeView() },
      ])
    }
  }
}
```

## Architecture

```txt
Genos
├── Global.swift        Global config: appScheme, authToken, paging defaults.
├── Router.swift        Deep link ↔ NavKey, convention based.
├── Http.swift          URLSession async/await + Codable with auth injection.
├── UiState.swift       loading, success, error.
├── Loader.swift        Detail-screen loader (@Observable).
├── Pager.swift         Page-number paginator for REST list endpoints.
├── ListView.swift      REST list screen with paging and states.
├── DetailView.swift    REST detail screen.
├── MarkdownText.swift  Markdown on the native AttributedString parser.
└── App.swift           GenosApp: TabView + NavigationStack shell, navigate environment.
```

## Samples

- `samples/catalog` — component catalog: list, detail, markdown with highlighted code,
  zoom shared-element transition, deep links, state restoration.
- `samples/airbnb` — replica of Airbnb: card explore with search and category chips,
  photo-carousel detail, wishlists (AppStorage), coral brand tint.
- `samples/instagram` — replica of Instagram: feed with stories, comments, explore and
  profile grids, monochrome tint.
- `samples/tiktok` — replica of TikTok: full-screen vertical video pager on native
  ScrollView paging + AVKit `VideoPlayer`.

## License

Genos is released under the Apache 2.0 license. [See LICENSE](LICENSE) for details.
