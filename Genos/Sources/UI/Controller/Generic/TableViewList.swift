//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

open class TableViewList<T: Decodable, V: UITableViewCell>: TableViewListController<[T], T, V> {
    open override func transformListFromData(data: [T]) -> [T] {
        data
    }
}
