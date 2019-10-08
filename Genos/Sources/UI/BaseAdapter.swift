//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

open class BaseAdapter<T: Any> {
    var list: [T] = []

    public func getItemCount() -> Int {
        return list.count
    }

    public func getItemViewType(_ indexPath: IndexPath) -> Int {
        return 0
    }

    public func getItem(_ indexPath: IndexPath) -> T {
        return list[indexPath.row]
    }

    public func getCurrentList() -> [T] {
        return list
    }

    public func addList(_ items: [T]) {
        list += items
    }

    public func add(_ item: T) {
        list.append(item)
    }

    public func removeAll(keepingCapacity: Bool = true) {
        list.removeAll(keepingCapacity: keepingCapacity)
    }

    public func remove(_ index: Int) {
        list.remove(at: index)
    }
}
