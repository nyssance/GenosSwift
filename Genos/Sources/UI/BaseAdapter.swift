//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

open class BaseAdapter<T: Any> {
    var list: [T] = []

    public func getItemCount() -> Int {
        list.count
    }

    public func getItemViewType(_ indexPath: IndexPath) -> Int {
        0
    }

    public func getCurrentList() -> [T] {
        list
    }

    public func getItem(_ indexPath: IndexPath) -> T {
        list[indexPath.row]
    }

    public func addAll(_ items: [T]) {
        list += items
    }

    public func removeAll(keepingCapacity: Bool = true) {
        list.removeAll(keepingCapacity: keepingCapacity)
    }

    public func insert(_ index: Int, _ item: T) {
        list.insert(item, at: index)
    }

    public func remove(_ index: Int) {
        list.remove(at: index)
    }
}
