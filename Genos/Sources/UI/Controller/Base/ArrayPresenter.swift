//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

protocol ListViewConnectable {
    var indexPathsForSelectedItems: [IndexPath]? { get }

    func numberOfItems(inSection section: Int) -> Int

    func reloadData()
}

extension UICollectionView: ListViewConnectable {}

extension UITableView: ListViewConnectable {
    public var indexPathsForSelectedItems: [IndexPath]? { indexPathsForSelectedRows as [IndexPath]? }

    public func numberOfItems(inSection section: Int) -> Int {
        numberOfRows(inSection: section)
    }
}
