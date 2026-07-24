// SPDX-FileCopyrightText: 2020-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Foundation
import Genos

struct Stay: Codable, Identifiable {
  let id: Int
  let title: String
  let location: String
  let category: String
  let pricePerNight: Int
  let rating: Double
  let reviewCount: Int
  let host: String
  let guests: Int
  let bedrooms: Int
  let beds: Int
  let amenities: [String]
  let description: String
  let images: [String]
}

/// Local mock listings, the bundled JSON of the Android sample.
enum Stays {
  static let all: [Stay] = {
    let url = Bundle.main.url(forResource: "stays", withExtension: "json")!
    return try! JSONDecoder().decode([Stay].self, from: Data(contentsOf: url))
  }()

  static func page(_ page: Int, category: String?, query: String) -> [Stay] {
    guard page == Global.listStartPage else { return [] }
    return all.filter { stay in
      (category == nil || stay.category == category)
        && (query.isEmpty || stay.title.localizedCaseInsensitiveContains(query)
          || stay.location.localizedCaseInsensitiveContains(query))
    }
  }

  static func byId(_ id: Int) -> Stay {
    all.first { $0.id == id }!
  }
}
