//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

public protocol Styleable {
    var theme: Theme? { get set }
}

extension Styleable where Self: UIViewController {
    public func getTheme() -> Theme {
        return theme ?? APP_THEME
    }

    // swiftlint:disable function_body_length
    public func setNavigationBar(style: Theme.BarStyle, color: UIColor? = nil, image: UIImage? = nil, showTitle: Bool = false, statusBarStyle: UIStatusBarStyle = .lightContent, from: String) {
        log.verbose("\(style) \(from)")
        switch style {
        case .colorful: // 彩色导航栏
            extendedLayoutIncludesOpaqueBars = true
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            navigationController?.navigationBar.shadowImage = nil
            navigationController?.navigationBar.barStyle = .black
            navigationController?.navigationBar.barTintColor = color ?? getTheme().colorPrimary
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.isTranslucent = false
            UIApplication.shared.statusBarStyle = .lightContent
//            overide var preferredStatusBarStyle: UIStatusBarStyle {
//                return statusBarStyle
//            }
            navigationController?.navigationBar.titleTextAttributes?.removeValue(forKey: .foregroundColor)
        case .transparent: // 透明导航栏
            extendedLayoutIncludesOpaqueBars = false
            if image == nil { // 无图片时为全屏风格
                // listView.contentInsetAdjustmentBehavior = .never TODO
            } else {
                let imageView = ImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: topBarHeight))
                imageView.image = image
                view.addSubview(imageView)
            }
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.barStyle = .black
            navigationController?.navigationBar.barTintColor = nil
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.isTranslucent = true
            UIApplication.shared.statusBarStyle = statusBarStyle
            if showTitle {
                navigationController?.navigationBar.titleTextAttributes?.removeValue(forKey: .foregroundColor)
            } else {
                navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.clear]
            }
            if !hidesBottomBarWhenPushed {
                //                if let listView = view.subviews.last as? UIScrollView { //TODO
                //                    fixListViewHeight(listView: listView, tabBarController: tabBarController) // 解决透明导航栏时被tabBar遮挡
                //                }
            }
        case .light:
            setNav()
            navigationController?.navigationBar.isTranslucent = false
            // iOS 11 上处理阴影线
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
        case .lightComplete:
            setNav()
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
        default: // 默认导航栏
            setNav()
        }
    }

    func setNav() {
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.barTintColor = nil
        navigationController?.navigationBar.tintColor = getTheme().navigationBarTintColor
        navigationController?.navigationBar.isTranslucent = true
        UIApplication.shared.statusBarStyle = .default
        navigationController?.navigationBar.titleTextAttributes = getTheme().titleTextAttributes
        navigationController?.navigationBar.largeTitleTextAttributes = getTheme().largeTitleTextAttributes
    }

    /// 隐藏返回菜单.
    /// 1. 如果目标 Controller 需求效果不同, 放在 onSegue 中判断不同 destination 调用, 但横滑一半再返回可能出问题.
    /// 2. 如果相同, 在 viewWillAppear 调用, 不能在 onCreate中 调用, 为了实现 1, 每次在 viewWillAppear 中做了还原, 未继承 BaseController时 使用效果 1 需要手动还原.
    public func setBackBarButtonItem(title: String?) {
        navigationItem.backBarButtonItem = title == nil ? nil : UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
    }

    public func setToolbar(style: Theme.BarStyle) {
        switch style {
        case .transparent: // 透明工具栏
            navigationController?.toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
            navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
            navigationController?.toolbar.tintColor = .white
        default:
            break
        }
    }
}
