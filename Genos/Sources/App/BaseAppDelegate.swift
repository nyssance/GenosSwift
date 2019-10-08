//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

import IQKeyboardManagerSwift
import SwiftyBeaver

public let log = SwiftyBeaver.self

open class BaseAppDelegate: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?
    public var blurView: UIVisualEffectView?

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        window?.backgroundColor = .white // 防止导航右侧阴影闪动
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false // 默认IQ键盘无工具条
        do {
            let console = ConsoleDestination()
            console.format = """
            $DHH:mm:ss.SSS$d $C$c├─ $N.$F: $l 行
                            └─── $M $X
            """
            log.addDestination(console) // Add to SwiftyBeaver.
        }
        Global.config()
        onFinishLaunching(application, launchOptions: launchOptions)
        blurView?.frame = UIScreen.main.bounds
        _ = blurView?.addVibrancyView()
        return true
    }

    open func applicationDidEnterBackground(_ application: UIApplication) {
        if let view = blurView { // 后台模糊
            window?.addSubview(view)
        }
    }

    public func applicationWillEnterForeground(_ application: UIApplication) {
        blurView?.removeFromSuperview()
    }

    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        log.error("APNs 注册失败 \(error.localizedDescription)")
    }

    // MARK: - 👊 Genos

    open func onFinishLaunching(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {}

    public func initWindow(_ rootViewController: UIViewController) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
}
