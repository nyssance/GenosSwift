//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

import JSSAlertView
import SwiftIcons

public func showDebugAlert(title: String = "debug".locale, _ message: String, color: UIColor = .colorWithHex(0x3498DB)) {
    log.error(message, context: title)
    if isDebug {
        let iconImage = UIImage(icon: .fontAwesomeSolid(.lightbulb), size: CGSize(width: 72, height: 72), textColor: .white)
        let alert = JSSAlertView().show(currentViewController, title: title, text: message, buttonText: "请通知程序员修复".locale, color: color, iconImage: iconImage)
        alert.setTitleFont(".SFUIText-Light")
        alert.setTextFont(".SFUIText")
        alert.setButtonFont(".SFUIText-Bold")
        alert.setTextTheme(.light)
    }
}

public var currentViewController: UIViewController {
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
