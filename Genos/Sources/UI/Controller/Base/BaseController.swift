//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

import Photos

import DeviceKit
import SwiftEventBus

open class BaseController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, Styleable {
    // MARK: - 🍀 变量

    public var progressView: UIProgressView!
    public var theme: Theme? // 每个页面当前的theme

    public var isStatusBarHidden = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    open override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }

    var UITag: String {
        return String(describing: classForCoder).components(separatedBy: "<").first?.underscored() ?? "没有 UITag"
    }

    // MARK: - 💖 生命周期 (Lifecycle)

    public final override func loadView() {
        super.loadView()
        navigationController?.navigationBar.prefersLargeTitles = getTheme().prefersLargeTitles
        navigationItem.largeTitleDisplayMode = .always
        if !(self is WebController) { // WebController默认无title
            title = title ?? UITag.replacingOccurrences(of: "_list", with: "s").locale // 从上一个界面传入destination.title 或 从UITag生成
        }
        onBeforeCreate()
        onCreate()
        onAfterCreate()
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        log.verbose("==================== \(UITag) ====================")
        setNavigationBar(style: getTheme().navigationBarStyle, from: "base did load") // 导航栏风格
        navigationController?.toolbar.tintColor = getTheme().colorPrimary // 工具栏风格
        // 进度条
        progressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 2))
        progressView.progressTintColor = getTheme().navigationBarProgressTintColor
        progressView.trackTintColor = .clear
        if navigationController == nil {
            view.addSubview(progressView)
        } else {
            progressView.frame.origin.y = NAVIGATION_BAR_HEIGHT
//            navigationController?.navigationBar.layer.addSublayer(progressView.layer)
            navigationController?.navigationBar.addSubview(progressView)
        }
        SwiftEventBus.onMainThread(self, name: "mainEvent") { result in
            self.onEventReceived(result?.object, userInfo: result?.userInfo)
        } // 注册Event接收器
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.backBarButtonItem = nil // 还原返回菜单
        setBackBarButtonItem(title: getTheme().backItemStyle)
        Global.onViewWillAppear(self)
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setNavigationBar(style: getTheme().navigationBarStyle, from: "base will disapper") // 恢复设定值
        Global.onViewWillDisappear(self)
    }

    deinit {
        SwiftEventBus.unregister(self)
    }

    // MARK: - 💟 加载数据, 子类必须调用

    public func onBeforeCreate() {}

    open func onCreate() {}

    public func onAfterCreate() {}

    open func onEventReceived(_ sender: Any?, userInfo: [AnyHashable: Any]?) {}

    public func sendEvent(_ userInfo: [AnyHashable: Any]) {
        SwiftEventBus.post("mainEvent", sender: self, userInfo: userInfo)
    }
}

extension BaseController {
    public func startImageSheet(allowsEditing: Bool = false) {
        let picker = UIImagePickerController()
        picker.allowsEditing = allowsEditing
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "camera".locale, style: .default) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
                if [.restricted, .denied].contains(status) {
                    showAlert(self, message: "请在iPhone的“设置-隐私-相机”选项中，允许\(InfoPlistUtils.APP_DISPLAY_NAME)访问你的相机")
                    // showSettingsAlert(self, title: "相机未授权", message: "请允许使用相机")
                } else {
                    picker.sourceType = .camera
                    picker.delegate = self
                    self.present(picker, animated: true, completion: nil)
                }
            } else {
                showAlert(self, message: Device.current.isSimulator ? "模拟器没有相机" : "相机不存在, 可能已损坏")
            }
        })
        alert.addAction(UIAlertAction(title: "photos".locale, style: .default) { _ in
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        })
        showActionSheet(controller: self, alert: alert)
    }
}
