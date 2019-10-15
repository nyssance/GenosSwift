//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

public struct Pagination {
    var count = 0
    var next: String?
    var previous: String?
}

public protocol Listable {
    var pagination: Pagination { get set }
    var page: Int { get set }
    var nextPage: Int { get set }

    func hasNext() -> Bool
    func hasPrevious() -> Bool
    func loadMore(_ indexPath: IndexPath)
}

open class CollectionViewListController<D: Decodable, T: Decodable, V: UICollectionViewCell>: CollectionViewController<D, T, V>, Listable {
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
        if !hasPrevious() { // 如果无上一页, 完全重载
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
            //        loader?.load(call)
        }
        super.refresh()
    }

//    func loadMore<E: UIScrollView>(listView: E, indexPath: IndexPath) where E: ListViewConnectable {
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

    // MARK: - 🔹 UICollectionViewDelegate

    public final override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        loadMore(indexPath)
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
}
