//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

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

public extension UIViewController {
    var topBarHeight: CGFloat { UIApplication.shared.statusBarFrame.size.height + (navigationController?.navigationBar.frame.height ?? 0) }

    func navigateTo(_ destination: UIViewController, animated: Bool = true) {
        destination.hidesBottomBarWhenPushed = true // 导航栏右侧黑影修复方法, 在AppDelegate设置UIWindow背景为白色 SO https://stackoverflow.com/questions/22516046/ios7-strange-animation-when-using-hidesbottombarwhenpushed
        navigationController?.pushViewController(destination, animated: animated) // 手动push
    }

    // swiftlint:disable cyclomatic_complexity function_body_length
    func navigate(_ item: Item) {
        guard item.link.isNotBlank else {
            showDebugAlert("空 link")
            return
        }
        guard let url = URL(string: item.link) else {
            showDebugAlert("\(item.link) 无法转成URL")
            return
        }
        switch url.scheme.orEmpty() {
        case APP_SCHEME:
            if let dest = item.destination?.init() {
                if item.title.isNotBlank { // 如果item的title不为空, 用item的title
                    dest.title = item.title
                }
                navigateTo(dest)
            } else {
                if let host = url.host {
                    switch host {
                    case "home":
                        tabBarController?.selectedIndex = 0
                        navigationController?.popToRootViewController(animated: true)
                    case "back", "close":
                        navigationController?.popViewController(animated: true)
                    case "version":
                        navigateTo(Version())
                    case "browser":
                        url.query?.let { query in
                            query.components(separatedBy: "&").forEach { it in
                                let component = it.components(separatedBy: "=")
                                if component[0] == "link" {
                                    component[1].removingPercentEncoding?.let {
                                        navigate(Item(link: $0))
                                    }
                                }
                            }
                        }
                    default:
                        Navigator.routes(self, path: item.link)
                    }
                } else { // 仿Chrome, chrome://跳转到chrome://version
                    navigate(Item(link: "\(APP_SCHEME)://version"))
                }
            }
        case "http":
            showAlert("为了安全不支持http, 请使用https链接。")
        case "https":
            // let options = [UIApplicationOpenURLOptionUniversalLinksOnly : true]
            // UIApplication.shared.open(url, options: options)
            let dest = WebController()
            if item.title.isNotBlank { // 如果item的title不为空, 用item的title
                dest.title = item.title
            }
            dest.link = item.link
            navigateTo(dest)
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
            showDebugAlert("未知 link: \(item.link)")
        }
    }

    // MARK: - 💛 Action

    // swiftlint:enable cyclomatic_complexity function_body_length

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
