// SPDX-FileCopyrightText: 2020-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Genos
import SwiftUI

private let categories = ["Cabins", "Beach", "City", "Countryside", "Trending"]

struct ExploreView: View {
  @Environment(\.navigate) private var navigate
  @State private var query = ""
  @State private var category: String?

  private var stays: [Stay] {
    Stays.page(Global.listStartPage, category: category, query: query)
  }

  var body: some View {
    ScrollView {
      LazyVStack(spacing: 24) {
        chips
        ForEach(stays) { stay in
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
    .navigationTitle("Explore")
    .searchable(text: $query, prompt: "Where to?")
  }

  private var chips: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 8) {
        ForEach(categories, id: \.self) { name in
          Button {
            category = category == name ? nil : name
          } label: {
            Text(name)
              .font(.subheadline.weight(.medium))
              .padding(.horizontal, 14)
              .padding(.vertical, 8)
              .background(
                Capsule().fill(category == name ? Color(.systemGray5) : Color(.systemBackground))
              )
              .overlay(Capsule().stroke(Color(.systemGray4)))
          }
          .buttonStyle(.plain)
        }
      }
      .padding(.vertical, 2)
    }
  }
}

struct StayCard: View {
  let stay: Stay

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      AsyncImage(url: URL(string: stay.images[0])) { image in
        image.resizable().scaledToFill()
      } placeholder: {
        Color(.systemGray6)
      }
      .frame(height: 280)
      .clipShape(RoundedRectangle(cornerRadius: 16))
      .overlay(alignment: .topTrailing) {
        WishlistButton(id: stay.id)
          .padding(10)
      }
      HStack {
        Text(stay.location).font(.headline)
        Spacer()
        Label(String(format: "%.2f", stay.rating), systemImage: "star.fill")
          .font(.subheadline)
          .labelStyle(.titleAndIcon)
          .foregroundStyle(.primary)
      }
      Text(stay.title).font(.subheadline).foregroundStyle(.secondary)
      Text("$\(stay.pricePerNight) night").font(.subheadline.weight(.semibold))
    }
  }
}

struct WishlistButton: View {
  let id: Int

  private let wishlist = Wishlist.shared

  var body: some View {
    Button {
      wishlist.toggle(id)
    } label: {
      Image(systemName: wishlist.contains(id) ? "heart.fill" : "heart")
        .font(.system(size: 20, weight: .semibold))
        .foregroundStyle(wishlist.contains(id) ? Color(red: 1, green: 0.22, blue: 0.36) : .white)
        .shadow(color: .black.opacity(0.4), radius: 3)
    }
    .buttonStyle(.plain)
  }
}
