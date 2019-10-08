//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

open class TableSearch: TableViewList<String, UITableViewCell>, UISearchBarDelegate {
    var searchController: UISearchController!

    // MARK: - 🐤 Taylor

    open override func onViewCreated() {
        searchController = UISearchController()
        searchController.searchResultsUpdater = searchController.searchResultsController as? UISearchResultsUpdating
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit() // 放在设置tableHeaderView前保证无scopeBar时第一行不被挡掉
        listView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true // 保证不将searchBar带入下一个界面
    }

    // MARK: - 💜 UISearchBarDelegate

    public func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchController.searchResultsUpdater?.updateSearchResults(for: searchController)
    }
}
