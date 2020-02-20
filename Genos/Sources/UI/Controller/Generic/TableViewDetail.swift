//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

open class TableViewDetail<D: Decodable, T: Item, V: UITableViewCell>: GroupedTableViewController<D, T, V> {
    // MARK: - 👊 Genos

    public override func onBeforeCreate() {
        super.onBeforeCreate()
        tableViewCellStyle = .value1
    }

    open override func onDisplayItem(item: T, view: V, viewType: Int) {
        super.onDisplayItem(item: item, view: view, viewType: viewType)
        view.accessoryType = item.enabled ? .none : .disclosureIndicator
    }

    open override func onOpenItem(item: T) {
        if let dest = item.destination?.init() {
            if item.title.isNotBlank { // 如果item的title不为空, 用item的title
                dest.title = item.title
            }
            navigateTo(dest)
        } else if let link = item.link, link.isNotBlank {
            navigateTo(link, title: item.title)
        }
    }
}
