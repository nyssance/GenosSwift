//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

public extension UITableView {
    func deselectAll(animated: Bool) {
        _ = indexPathsForSelectedRows?.map { deselectRow(at: $0, animated: animated) }
    }
}
