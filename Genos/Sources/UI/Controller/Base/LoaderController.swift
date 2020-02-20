//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

public enum RefreshMode: Int, CaseIterable {
    case didLoad, willAppear, didAppear, never
}

public enum RefreshControlMode: Int, CaseIterable {
    case always, never
}

public enum Action: Int, CaseIterable {
    case open, refresh, share
}

open class LoaderController<D: Decodable>: BaseController {
    // MARK: - 🍀 属性

    public var viewModel = BaseViewModel<D>()
    public var call: Call<D>?
    public var loader: BaseLoader<D>?
    /// LoaderController 默认为 didLoad, 每次进来刷一次, FormController 为 never.
    public var refreshMode = RefreshMode.didLoad
    public var refreshControlMode = RefreshControlMode.always
    public var isLoading = false

    var scrollView: UIScrollView?

    public final func getData() -> D? {
        viewModel.data
    }

    public final func setData(_ data: D?) {
        viewModel.data = data
    }

    // MARK: - 💖 生命周期 (Lifecycle)

    public final override func viewDidLoad() {
        super.viewDidLoad()
        loader = onCreateLoader()
        loader?.delegate = self // 设置监听
        if call == nil { // 如果call为空, 刷新模式自动为never
            refreshMode = .never
            refreshControlMode = .never
        }
        onCreateView()
        // 下拉刷新
        if refreshControlMode == .always {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
            scrollView?.refreshControl = refreshControl
        }
        onViewCreated()
        if refreshMode == .didLoad {
            refresh()
        }
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if scrollView is UITableView {
            (scrollView as? UITableView)?.deselectAll(animated: animated) // tableView回滑时选中平滑消失
        }
        if refreshMode == .willAppear {
            refresh()
        }
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if refreshMode == .didAppear {
            refresh()
        }
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isLoading = false // 还原, 主要针对表单提交 TODO 看看有没有更好的方法
    }

    func onCreateView() {}

    open func onViewCreated() {}

    open func onCreateLoader() -> BaseLoader<D>? {
        if let call = call {
            let loaderType: BaseLoader<D>.Type = HttpLoader<D>.self
            return loaderType.init(call: call)
        } else {
            log.warning("call is nil, 确定该界面没有call么")
            return nil
        }
    }

    open func onDataLoadSuccess(_ status: Int, data: D) {
        setData(data)
        onDisplay(data: data)
    }

    open func onDataLoadFailure(_ status: Int, message: String) {
        let msg = (isDebug ? "\(call?.endpoint as Optional)\n\n" : "") + message
        switch status {
        case 401:
            log.debug(msg)
            navigateTo("login")
        default:
            showAlert("🐳 \(status)", msg)
        }
    }

    public final func onDataLoadComplete() {
        isLoading = false
        if scrollView?.refreshControl?.isRefreshing ?? false {
            scrollView?.refreshControl?.endRefreshing()
        }
    }

    /// 暂时不用.
    public func onDataChanged(_ data: D?, status: Int, message: String) {
        onDataLoadComplete()
        if let data = data {
            onDataLoadSuccess(status, data: data)
        } else {
            onDataLoadFailure(status, message: message)
        }
    }

    open func onDisplay(data: D) {}

    // MARK: - 💛 Action

    @objc
    public func refresh() { // 下拉刷新需要
        if call != nil {
            isLoading = true
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                if self.isLoading { // 显示加载Modal对话框
                }
            }
            loader?.load()
            // viewModel.loadData(call)
        }
    }
}
