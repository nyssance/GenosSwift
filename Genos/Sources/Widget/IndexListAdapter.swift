//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

open class IndexListAdapter<T: Any>: BaseAdapter<T> {
    private var indexer: [Int] = []

    public func transformItemsToList(_ items: [[T]]) {
        var i = 0
        items.forEach { section in
            indexer.append(i)
            section.forEach { it in
                list.append(it)
            }
            i += section.count
        }
    }

    public func getSectionCount() -> Int {
        // return items.isEmpty ? 1 : items.count
        return indexer.isEmpty ? 1 : indexer.count
    }

    public func getSectionItemCount(_ section: Int) -> Int {
        // return items.isEmpty ? getItemCount() : items[section].count
        return indexer.isEmpty ? getItemCount() : (section < indexer.count - 1 ? indexer[section + 1] : getItemCount()) - indexer[section]
    }

    public override func getItem(_ indexPath: IndexPath) -> T {
        // return items.isEmpty ? super.getItem(indexPath) : items[indexPath.section][indexPath.row]
        return indexer.isEmpty ? super.getItem(indexPath) : list[indexer[indexPath.section] + indexPath.row]
    }
}
