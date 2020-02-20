//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

public extension UIViewController {
    var topBarHeight: CGFloat { UIApplication.shared.statusBarFrame.size.height + (navigationController?.navigationBar.frame.height ?? 0) }

    /// 退出当前界面.
    @objc
    final func cancel(_ animated: Bool = true) {
        if navigationController == nil || navigationController?.viewControllers.first == self { // 如果无导航栏或为导航栏第一个View
            dismiss(animated: animated, completion: nil)
        } else {
            navigationController?.popViewController(animated: animated)
        }
    }
}

public extension UIViewController {
    var url: URL? {
        get { nil }
        set {}
    }

    func navigateTo(_ link: String, title: String = "", animated: Bool = true) {
        let url = URL(string: link.contains("://") ? link : "\(APP_SCHEME)://\(link)") ?? URL(string: "exception")!
        switch url.scheme.orEmpty() {
        case APP_SCHEME:
            if let route = routes.first(where: { $0.key == link.removePrefix("\(APP_SCHEME)://") }) {
                navigateTo(route.value.init(), animated: animated)
            } else {
                let host = url.host.orEmpty()
                switch host {
                case "home":
                    tabBarController?.selectedIndex = 0
                    navigationController?.popToRootViewController(animated: true)
                case "back", "close":
                    navigationController?.popViewController(animated: true)
                case "browser":
                    url.query?.let { query in
                        query.components(separatedBy: "&").forEach { it in
                            let component = it.components(separatedBy: "=")
                            if component[0] == "link" {
                                component[1].removingPercentEncoding?.let {
                                    navigateTo($0, animated: animated)
                                }
                            }
                        }
                    }
                default:
                    let name: String
                    switch host {
                    case "": name = "version" // 仿Chrome, chrome://跳转到chrome://version
                    case "about", "credits", "discards", "help",
                         "settings", "system", "profile", "version": name = host
                    default: name = "\(host.singularize())\(url.path.isBlank ? "List" : "Detail")"
                    }
                    if let destType = NSClassFromString("\(InfoPlistUtil.APP_NAME).\(name.capitalized)").self as? UIViewController.Type {
                        let dest = destType.init()
                        navigateTo(dest, animated: animated)
                    } else if let destType = NSClassFromString("Genos.\(name)").self as? UIViewController.Type {
                        let dest = destType.init()
                        navigateTo(dest, animated: animated)
                    } else {
                        showAlert("ERR_UNKNOWN_URI", link)
                    }
                }
            }
        case "https":
            let dest = WebController()
            if title.isNotBlank { // 如果item的title不为空, 用item的title
                dest.title = title
            }
            dest.link = link
            navigateTo(dest, animated: animated)
        case "itms", "itms-apps", "mailto", "maps", "sms", "tel":
            UIApplication.shared.open(url)
        case let scheme where ShareUtil.THIRD_PARTY_APPS.keys.contains(scheme):
            URL(string: "\(scheme)://")?.let { it in
                if UIApplication.shared.canOpenURL(it) {
                    UIApplication.shared.open(it)
                } else {
                    showAlert("请安装 \(ShareUtil.THIRD_PARTY_APPS[scheme]!.locale)") // TODO: 解决强转
                }
            }
        default:
            // let url = URL(string: "APP-Prefs:root=WIFI") TODO 处理系统跳转 iOS10之后是否可行
            showAlert("ERR_UNKNOWN_URL_SCHEME", link)
        }
    }

    final func navigateTo(_ viewController: UIViewController, animated: Bool = true) {
        viewController.hidesBottomBarWhenPushed = true // 导航栏右侧黑影修复方法, 在AppDelegate设置UIWindow背景为白色 SO https://stackoverflow.com/questions/22516046/ios7-strange-animation-when-using-hidesbottombarwhenpushed
        navigationController?.pushViewController(viewController, animated: animated) // 手动push
    }
}

public extension UIViewController {
    final func showLoginUI() { // present跳转增加导航栏
        present(UINavigationController(rootViewController: SIGN_IN_CONTROLLER.init()), animated: true, completion: nil)
    }

    final func showActionSheet(_ alert: UIAlertController, cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        alert.addAction(UIAlertAction(title: "cancel".locale, style: .cancel, handler: cancelHandler))
        alert.popoverPresentationController?.sourceView = view // 适配iPad
        alert.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 2)
        present(alert, animated: true, completion: nil)
    }

    final func showAlert(_ title: String?, _ message: String? = nil, action: UIAlertAction? = nil, cancelButtonTitle: String? = nil, cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelButtonTitle ?? (action == nil ? "ok" : "cancel").locale, style: .cancel, handler: cancelHandler))
        action?.let {
            alert.addAction($0)
        }
        present(alert, animated: true, completion: nil)
    }

    final func showSettingsAlert(_ title: String, _ message: String) {
        showAlert(title, message, action: UIAlertAction(title: "settings".locale, style: .default) { _ in
            URL(string: UIApplication.openSettingsURLString)?.let {
                UIApplication.shared.open($0) // 开启设置
            }
        })
    }
}
