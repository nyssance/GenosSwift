//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

import JSSAlertView
import SwiftIcons

public func showLoginUI(_ controller: UIViewController) { // present跳转增加导航栏
    controller.present(UINavigationController(rootViewController: SIGN_IN_CONTROLLER.init()), animated: true, completion: nil)
}

public func showActionSheet(_ controller: UIViewController, _ alert: UIAlertController, cancelHandler: ((UIAlertAction) -> Void)? = nil) {
    alert.addAction(UIAlertAction(title: "cancel".locale, style: .cancel, handler: cancelHandler))
    alert.popoverPresentationController?.sourceView = controller.view // 适配iPad
    alert.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: controller.view.frame.width, height: controller.view.frame.height / 2)
    controller.present(alert, animated: true, completion: nil)
}

public func showAlert(_ controller: UIViewController?, title: String? = nil, message: String?, action: UIAlertAction? = nil, cancelButtonTitle: String? = nil, cancelHandler: ((UIAlertAction) -> Void)? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: cancelButtonTitle ?? (action == nil ? "ok" : "cancel").locale, style: .cancel, handler: cancelHandler))
    action?.let {
        alert.addAction($0)
    }
    (controller ?? getCurrentViewController()).present(alert, animated: true, completion: nil)
}

public func showDebugAlert(title: String = "debug".locale, _ message: String, color: UIColor = .colorWithHex(0x3498DB)) {
    log.error(message, context: title)
    if isDebug {
        let iconImage = UIImage(icon: .fontAwesomeSolid(.lightbulb), size: CGSize(width: 72, height: 72), textColor: .white)
        let alert = JSSAlertView().show(getCurrentViewController(), title: title, text: message, buttonText: "请通知程序员修复".locale, color: color, iconImage: iconImage)
        alert.setTitleFont(".SFUIText-Light")
        alert.setTextFont(".SFUIText")
        alert.setButtonFont(".SFUIText-Bold")
        alert.setTextTheme(.light)
    }
}

public func showSettingsAlert(controller: UIViewController?, title: String, message: String) {
    showAlert(controller, title: title, message: message, action: UIAlertAction(title: "settings".locale, style: .default) { _ in
        URL(string: UIApplication.openSettingsURLString)?.let { it in
            UIApplication.shared.open(it) // 开启设置
        }
    })
}

public func getCurrentViewController() -> UIViewController {
    // SO https://stackoverflow.com/questions/24825123/get-the-current-view-controller-from-the-app-delegate
    func findBestViewController(_ controller: UIViewController?) -> UIViewController? {
        if let presented = controller?.presentedViewController { // Presented界面
            return findBestViewController(presented)
        } else {
            switch controller {
            case is UISplitViewController: // Return right hand side
                let split = controller as? UISplitViewController
                guard split?.viewControllers.isEmpty ?? true else {
                    return findBestViewController(split?.viewControllers.last)
                }
            case is UINavigationController: // Return top view
                let navigation = controller as? UINavigationController
                guard navigation?.viewControllers.isEmpty ?? true else {
                    return findBestViewController(navigation?.topViewController)
                }
            case is UITabBarController: // Return visible view
                let tab = controller as? UITabBarController
                guard tab?.viewControllers?.isEmpty ?? true else {
                    return findBestViewController(tab?.selectedViewController)
                }
            default:
                break
            }
        }
        return controller
    }

    return findBestViewController(UIApplication.shared.keyWindow?.rootViewController)! // 假定永远有, 待处理强转
}
