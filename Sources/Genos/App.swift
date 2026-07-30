// SPDX-FileCopyrightText: 2018-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

/// Programmatic navigation: `navigate(key)` pushes a `NavKey` onto the current
/// tab's path, the `backStack.add` of Genos for Android.
extension EnvironmentValues {
  @Entry public var navigate: (any NavKey) -> Void = { _ in }
}

public struct GenosTab: Identifiable {
  public let id: String
  let title: String
  let systemImage: String
  let root: AnyView

  /// `id` defaults to the title; pass an explicit one when two tabs share a title.
  public init(
    _ title: String, systemImage: String, id: String? = nil, @ViewBuilder root: () -> some View
  ) {
    self.id = id ?? title
    self.title = title
    self.systemImage = systemImage
    self.root = AnyView(root())
  }
}

/// Persisted navigation (selected tab + one path per tab), restored across
/// process death — the `rememberNavBackStack` guarantee of Android.
private struct NavigationState: Codable {
  var selection: Int
  var paths: [NavigationPath.CodableRepresentation]
}

/// The app shell: TabView + one NavigationStack per tab, deep links resolved
/// through `Router` onto the current tab's path. Register destinations on the
/// tab roots with `.navigationDestination(for:)` — the `entry<T>` of Android.
public struct GenosApp: View {
  private let tabs: [GenosTab]
  private let deepLink: (any NavKey)?

  @State private var selection = 0
  @State private var paths: [NavigationPath]
  /// A cold-start deep link can arrive before navigation restore has run; it is
  /// buffered here so `restoreNavigation()` cannot clobber the push.
  @State private var restored = false
  @State private var pendingDeepLink: (any NavKey)?
  @SceneStorage("genos.navigation") private var navigationData: Data?
  @Environment(\.scenePhase) private var scenePhase

  public init(tabs: [GenosTab], deepLink: (any NavKey)? = nil) {
    self.tabs = tabs
    self.deepLink = deepLink
    _paths = State(initialValue: Array(repeating: NavigationPath(), count: tabs.count))
  }

  /// Single-stack form, the `GenosApp(startKey)` of Android: no tab bar.
  public init(deepLink: (any NavKey)? = nil, @ViewBuilder root: () -> some View) {
    tabs = [GenosTab("", systemImage: "", root: root)]
    self.deepLink = deepLink
    _paths = State(initialValue: [NavigationPath()])
  }

  public var body: some View {
    Group {
      if tabs.count == 1 {
        stack(0)
      } else {
        TabView(selection: $selection) {
          ForEach(Array(tabs.enumerated()), id: \.element.id) { index, tab in
            Tab(tab.title, systemImage: tab.systemImage, value: index) {
              stack(index)
            }
          }
        }
        // The flagship iOS 26 behavior (Music, App Store): the bar minimizes on scroll.
        .tabBarMinimizeBehavior(.onScrollDown)
      }
    }
    .onOpenURL { url in
      guard let key = Router.resolve(url) else { return }
      if restored {
        paths[selection].append(key)
      } else {
        pendingDeepLink = key
      }
    }
    .task {
      restoreNavigation()
      restored = true
      if let pending = pendingDeepLink {
        pendingDeepLink = nil
        paths[selection].append(pending)
      } else if let deepLink, paths[selection].isEmpty {
        paths[selection].append(deepLink)
      }
    }
    .onChange(of: scenePhase) { _, phase in
      if phase != .active { persistNavigation() }
    }
  }

  private func stack(_ index: Int) -> some View {
    NavigationStack(path: $paths[index]) {
      tabs[index].root
    }
    .environment(\.navigate) { key in
      paths[index].append(key)
    }
  }

  // MARK: - State restoration

  private func restoreNavigation() {
    guard let navigationData,
      let state = try? JSONDecoder().decode(NavigationState.self, from: navigationData),
      state.paths.count == tabs.count
    else { return }
    selection = min(max(0, state.selection), tabs.count - 1)
    paths = state.paths.map(NavigationPath.init)
  }

  private func persistNavigation() {
    // A path containing non-Codable values cannot be represented; skip persisting then.
    let representations = paths.compactMap(\.codable)
    guard representations.count == paths.count else { return }
    navigationData = try? JSONEncoder().encode(
      NavigationState(selection: selection, paths: representations))
  }
}
