//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

open class TableViewDetail<D: Decodable, T: Item, V: UITableViewCell>: GroupedTableViewController<D, T, V> {
    // MARK: - 🐤 Taylor

    public override func onBeforeCreate() {
        super.onBeforeCreate()
        tableViewCellStyle = .value1
    }

    open override func onDisplayItem(item: T, view: V, viewType: Int) {
        super.onDisplayItem(item: item, view: view, viewType: viewType)
        view.accessoryType = item.link.isBlank ? .none : .disclosureIndicator
    }

    open override func onOpenItem(item: T) {
        navigate(item)
    }
}
