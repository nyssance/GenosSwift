// SPDX-FileCopyrightText: 2020-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Genos
import SwiftUI

struct WishlistsView: View {
  @Environment(\.navigate) private var navigate

  private let wishlist = Wishlist.shared

  var body: some View {
    let saved = Stays.all.filter { wishlist.contains($0.id) }
    Group {
      if saved.isEmpty {
        ContentUnavailableView(
          "No saved stays", systemImage: "heart",
          description: Text("Tap the heart on any stay to save it here."))
      } else {
        ScrollView {
          LazyVStack(spacing: 24) {
            ForEach(saved) { stay in
              Button {
                navigate(StayDetail(id: stay.id))
              } label: {
                StayCard(stay: stay)
              }
              .buttonStyle(.plain)
            }
          }
          .padding(.horizontal, 20)
        }
      }
    }
    .navigationTitle("Wishlists")
  }
}
