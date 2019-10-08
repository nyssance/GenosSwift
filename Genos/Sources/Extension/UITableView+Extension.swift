//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

extension UITableView {
    public func deselectAll(animated: Bool) {
        _ = indexPathsForSelectedRows?.map { deselectRow(at: $0, animated: animated) }
    }
}
