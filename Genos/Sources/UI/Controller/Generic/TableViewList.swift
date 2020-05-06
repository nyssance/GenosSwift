//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

open class TableViewList<T: Decodable, V: UITableViewCell>: TableViewListController<[T], T, V> {
    override open func transformListFromData(data: [T]) -> [T] {
        data
    }
}
