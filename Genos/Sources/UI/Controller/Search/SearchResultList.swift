//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

open class SearchResultList<V: UITableViewCell>: TableViewList<SearchResult, V>, UISearchResultsUpdating {
    // MARK: - 👊 Genos

    open override func onCreate() {
        adapter.submitList([SearchResult(title: "aaa"), SearchResult(title: "bbb"), SearchResult(title: "ccc")])
    }

    open override func onDisplayItem(item: SearchResult, view: V, viewType: Int) {
        view.textLabel?.text = item.title
    }

    // MARK: - 🔹 UISearchResultsUpdating

    public func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text.orEmpty()
        // let dataArray = adapter.data.filter() { ($0 as? SearchResult)?.title.contains(searchString) ?? false }
        if searchString.isBlank {
            //            dataArray = originalData
        }
        // adapter.data = dataArray
        listView?.reloadData()
    }
}
