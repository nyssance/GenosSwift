//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

public extension Data {
    func getString() -> String? {
        var buffer = [UInt8](repeating: 0, count: count)
        copyBytes(to: &buffer, count: buffer.count)
        return String(bytes: buffer, encoding: .utf8)
    }
}
