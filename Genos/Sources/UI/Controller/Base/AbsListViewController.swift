//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

open class AbsListViewController<D: Decodable, T: Any, LV: UIScrollView, V: UIView>: LoaderController<D> {
    // MARK: - 🍀 属性

    public var listView: LV!
    public var adapter: IndexListAdapter<T> = IndexListAdapter()
    public var tileId: String { "list_item" }

    // MARK: - 👊 Genos

    override func onCreateView() {
        listView = onCreateListView().apply { it in
            it.alwaysBounceVertical = true // 永远可拖动
            it.backgroundColor = getTheme().colorBackground
            it.contentInset.bottom = tabBarController?.tabBar.frame.height ?? 0
        }
        view.addSubview(listView)
        scrollView = listView // 因为刷新全部移到LoaderController中，所以子类的scrollView要传递给LoaderController
    }

    func onCreateListView() -> LV {
        listView
        // fatalError("这个方法必须被覆盖")
    }

    open override func onDisplay(data: D) {
        super.onDisplay(data: data)
        (listView as? ListViewConnectable)?.reloadData()
    }

    // MARK: - 💛 绘制单元项, 子类必须调用

    open func onGetItemViewType(_ indexPath: IndexPath) -> Int {
        0
    }

    open func onDisplayItem(item: T, view: V, viewType: Int) {
        fatalError("这个方法必须被覆盖")
        // assert(false, "This method must be overriden")
    }

    open func onOpenItem(item: T) {
        showDebugAlert("onOpenItem() 必须在子类中被覆盖，或不允许点击该项")
        // fatalError("这个方法必须被覆盖")
    }

    open func onPerform(action: Action, item: T) {
        switch action {
        case .open:
            onOpenItem(item: item)
        default:
            break
        }
    }

    /// 处理light风格的滚动, 需要在TableViewController和CollectionViewController中分别继承
    open func onScrollViewDidScroll(_ scrollView: UIScrollView) {
        log.verbose("系统主题: \(APP_THEME.navigationBarStyle), 自定义主题: \(String(describing: theme != nil ? theme!.navigationBarStyle : nil)), 当前TopBar高度: \(topBarHeight)")
        if let navigationBar = navigationController?.navigationBar, getTheme().navigationBarStyle == .light {
            if topBarHeight == TOP_BAR_HEIGHT, navigationController?.navigationBar.shadowImage != nil {
                // iOS 11之后的light风格默认的线都去掉了, 无大标题的时候也需要需要补上, 利用scrollView进来默认刷一次的特性
                navigationBar.setBackgroundImage(nil, for: .default)
                navigationBar.shadowImage = nil
            } else if (TOP_BAR_HEIGHT + 1)...(TOP_BAR_HEIGHT + 5) ~= topBarHeight {
                navigationBar.setBackgroundImage(UIImage(), for: .default)
                navigationBar.shadowImage = UIImage()
            }
        }
    }

    /// 是否需要取消选中
    func needDeselect(_ item: T) -> Bool {
        if let it = item as? Item, it.isInternal() {
            return false // 如果不是app内调转或访问网页, 为外链app或动作, 取消选中.
        }
        return true
    }
}
