//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

public struct SearchResult: Codable {
    public var title = ""

    public init(title: String) {
        self.title = title
    }
}
