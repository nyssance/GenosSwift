//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

open class TableViewList<T: Decodable, V: UITableViewCell>: TableListController<[T], T, V> {
    open override func transformListFromData(data: [T]) -> [T] {
        return data
    }
}
