//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

open class GroupedTableViewController<D: Decodable, T: BaseItem, V: UITableViewCell>: TableViewController<D, T, V> {
    public var items: [[T]] = [] // NY 默认菜单项, 默认为多组, 不能初始化为[[]], 这样items.count为1而不是0
    public var mirror: Mirror?

    // MARK: - 👊 Genos

    public override func onBeforeCreate() {
        refreshControlMode = .never
        tableViewStyle = .grouped
    }

    public override func onAfterCreate() {
        adapter.transformItemsToList(items)
        if let data = getData() {
            mirror = Mirror(reflecting: data)
        }
    }

    open override func onDisplay(data: D) {
        mirror = Mirror(reflecting: data) // TODO: 有没有更好的位置放这段代码
        super.onDisplay(data: data)
    }

    open override func onDisplayItem(item: T, view: V, viewType: Int) {
        view.imageView?.image = item.icon
        view.textLabel?.text = item.title
        view.detailTextLabel?.text = item.subtitle
        if let mirror = mirror, let value = getValue(item.name.camelCased(), mirror: mirror), item.subtitle == nil { // 防止刚进入无数据时出错
            view.detailTextLabel?.text = viewModel.getDisplay(item.name, value: value)
        }
        if view is ItemRow { // 修正badge位置
            let badge = (view as? ItemRow)?.badge
            badge?.frame.origin.y += (view.frame.height - getTheme().rowHeight) / 2
        }
        if view.isMember(of: ItemRow.self) {
            getTheme().rowHeight = view.frame.height // FIXME: 这里有问题修改了全局
        }
    }

    // MARK: 🔹 UITableViewDelegate

    // SO https://stackoverflow.com/questions/39416385/swift-3-objc-optional-protocol-method-not-called-in-subclass Swift 3/4 泛型类中的 bug
    @objc(tableView:shouldHighlightRowAtIndexPath:)
    public final func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { // 在这里控制是否可选
        adapter.getItem(indexPath).enabled
    }
}

extension GroupedTableViewController {
    public func getSelected() -> [T] {
        listView.indexPathsForSelectedRows?.map { adapter.getItem($0) } ?? []
    }

    // SO https://stackoverflow.com/questions/33900604/swift-2-0-get-mirrored-superclass-properties
    func getValue(_ name: String, mirror: Mirror) -> Any? {
        var mirror: Mirror? = mirror
        repeat {
            for child in mirror!.children where name == child.label {
                return child.value
            }
            mirror = mirror?.superclassMirror
        } while mirror != nil
        return nil
    }
}
