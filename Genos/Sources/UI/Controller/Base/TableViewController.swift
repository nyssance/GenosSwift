//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

public enum MultiSelectedStyle: Int, CaseIterable {
    case `default`, checkmark
}

open class TableViewController<D: Decodable, T: Any, V: UITableViewCell>: AbsListViewController<D, T, UITableView, V>, UITableViewDataSource, UITableViewDataSourcePrefetching, UITableViewDelegate {
    // MARK: - 🍀 属性

    open var tableViewStyle = UITableView.Style.plain
    open var tableViewCellStyle = UITableViewCell.CellStyle.default
    open var multiSelectedStyle = MultiSelectedStyle.default

    // MARK: - 💖 生命周期 (Lifecycle)

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if [.light, .lightComplete].contains(getTheme().navigationBarStyle), listView.style == .grouped, listView.separatorStyle != .none {
            listView.visibleCells.first?.subviews.last?.isHidden = true
            listView.visibleCells.last?.subviews.last?.isHidden = true
        }
    }

    // MARK: - 👊 Genos

    public override func onCreateListView(y: CGFloat) -> UITableView {
        let tableView = UITableView(frame: CGRect(x: 0, y: y, width: view.frame.width, height: view.frame.height - y), style: tableViewStyle).apply { it in
            it.dataSource = self
            it.prefetchDataSource = self
            it.delegate = self
            if it.style == .plain { // 在plain模式下处理
                it.tableFooterView = UIView() // 无数据时不显示分割线, 参见DZNEmptyDataSet文档
                view.backgroundColor = .white // 保证有segment时返回顶部不会少一截
            } else { // grouped
//                it.contentInset.bottom = GROUP_TABLE_BOTTOM_HEIGHT - GROUP_TABLE_SECTION_FOOTER_HEIGHT
            }
        }
        return tableView
    }

    open func onMultipleSelected(cell: UITableViewCell?, indexPath: IndexPath) {
        switch multiSelectedStyle {
        case .checkmark:
            cell?.accessoryType = .checkmark
            cell?.selectionStyle = .none
        default:
            break
        }
    }

    // MARK: - 🔹 UITableViewDataSource

    public final func numberOfSections(in tableView: UITableView) -> Int {
        adapter.getSectionCount()
    }

    public final func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        adapter.getSectionItemCount(section)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // NY 不采用register配合dequeueReusableCell(withIdentifier:for:)方法, 方便UITableViewCell传参
        tableView.dequeueReusableCell(withIdentifier: tileId) ?? V.init(style: tableViewCellStyle, reuseIdentifier: tileId)
    }

    // MARK: 🔹 UITableViewDataSourcePrefetching

    open func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {}

    // MARK: 🔹 UITableViewDelegate

    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        getTheme().rowHeight
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let view = cell as? V {
            onDisplayItem(item: adapter.getItem(indexPath), view: view, viewType: onGetItemViewType(indexPath))
        } else {
            log.error("cell 类型 或 初始化 出错, 导致为空")
        }
    }

    public final func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.allowsMultipleSelection || (tableView.allowsMultipleSelectionDuringEditing && tableView.isEditing) { // 多选
            onMultipleSelected(cell: tableView.cellForRow(at: indexPath), indexPath: indexPath)
        } else { // 单选
            let item = adapter.getItem(indexPath)
            onPerform(action: .open, item: item)
            if needDeselect(item) {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }

    public final func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        switch multiSelectedStyle {
        case .checkmark:
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        default:
            break
        }
    }

    // MARK: 🔹 UIScrollViewDelegate

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onScrollViewDidScroll(scrollView)
    }
}
