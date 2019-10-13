//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

open class TableViewListController<D: Decodable, T: Decodable, V: UITableViewCell>: TableViewController<D, T, V>, Listable {
    // MARK: - 🍀 属性

    public var pagination = Pagination()
    public var page = LIST_START_PAGE
    public var nextPage = LIST_START_PAGE

    open func transformListFromData(data: D) -> [T] {
        []
    }

    open func hasNext() -> Bool {
        true
    }

    open func hasPrevious() -> Bool {
        page > LIST_START_PAGE
    }

    // MARK: - 👊 Genos

    open override func onDisplay(data: D) {
        nextPage += 1
        page = nextPage - 1
        if !hasPrevious() { // 如果无翻页或为第一页, 完全重载
            adapter.removeAll()
        }
        adapter.addAll(transformListFromData(data: data))
        super.onDisplay(data: data)
    }

    public override func refresh() {
        if var call = call {
            page = LIST_START_PAGE
            call.endpoint = call.endpoint.replacingOccurrences(of: "page=\(nextPage)", with: "page=\(page)")
            nextPage = LIST_START_PAGE
            loader?.call = call
        }
        super.refresh()
    }

    open func loadMore(_ indexPath: IndexPath) {
        if !hasNext() || isLoading {
            return
        }
        if indexPath.row == listView.numberOfItems(inSection: 0) - 1, var call = call {
            isLoading = true
            call.endpoint = call.endpoint.replacingOccurrences(of: "page=\(page)", with: "page=\(nextPage)")
            loader?.load(call) // 下一页
        }
    }

    // MARK: - 🔹 UITableViewDelegate

    public final override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        loadMore(indexPath)
        super.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
    }
}
