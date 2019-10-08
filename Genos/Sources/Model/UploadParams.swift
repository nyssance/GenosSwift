//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

public struct UploadParams: Codable {
    var endpoint = ""
    var params = ["": ""]

    enum CodingKeys: String, CodingKey {
        case endpoint
        case params
    }
}
