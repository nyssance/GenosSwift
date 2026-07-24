// SPDX-FileCopyrightText: 2020-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Genos
import SwiftUI

struct StayDetailView: View {
  let id: Int

  var body: some View {
    let stay = Stays.byId(id)
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        TabView {
          ForEach(stay.images, id: \.self) { image in
            AsyncImage(url: URL(string: image)) { image in
              image.resizable().scaledToFill()
            } placeholder: {
              Color(.systemGray6)
            }
          }
        }
        .tabViewStyle(.page)
        .frame(height: 300)
        .clipped()
        VStack(alignment: .leading, spacing: 8) {
          Text(stay.title).font(.title2.bold())
          Text(stay.location).foregroundStyle(.secondary)
          Text("\(stay.guests) guests · \(stay.bedrooms) bedroom · \(stay.beds) beds")
            .font(.subheadline)
            .foregroundStyle(.secondary)
          Label(
            "\(String(format: "%.2f", stay.rating)) · \(stay.reviewCount) reviews",
            systemImage: "star.fill"
          )
          .font(.subheadline)
          Divider()
          Text("Hosted by \(stay.host)").font(.headline)
          Text(stay.description)
          Divider()
          Text("Amenities").font(.headline)
          ForEach(stay.amenities, id: \.self) { amenity in
            Label(amenity, systemImage: "checkmark")
              .font(.subheadline)
          }
        }
        .padding(.horizontal, 20)
      }
    }
    .navigationTitle(stay.location)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        WishlistButton(id: stay.id)
      }
    }
    .safeAreaInset(edge: .bottom) {
      HStack {
        Text("$\(stay.pricePerNight) night").font(.headline)
        Spacer()
        Button("Reserve") {}
          .buttonStyle(.borderedProminent)
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 10)
      .background(.bar)
    }
  }
}
