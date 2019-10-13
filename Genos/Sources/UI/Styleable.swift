//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

public protocol Styleable {
    var theme: Theme? { get set }
}

public extension Styleable where Self: UIViewController {
    func getTheme() -> Theme {
        theme ?? APP_THEME
    }

    // swiftlint:disable function_body_length
    func setNavigationBar(style: Theme.BarStyle, color: UIColor? = nil, image: UIImage? = nil, showTitle: Bool = false, from: String) {
        log.verbose("\(style) \(from)")
        navigationController?.navigationBar.let { navigationBar in
            switch style {
            case .colorful: // 彩色导航栏
                extendedLayoutIncludesOpaqueBars = true
                navigationBar.setBackgroundImage(nil, for: .default)
                navigationBar.shadowImage = nil
                navigationBar.barStyle = .black
                navigationBar.barTintColor = color ?? getTheme().colorPrimary
                navigationBar.tintColor = .white
                navigationBar.isTranslucent = false
                navigationBar.titleTextAttributes?.removeValue(forKey: .foregroundColor)
            case .transparent: // 透明导航栏
                extendedLayoutIncludesOpaqueBars = false
                if image == nil { // 无图片时为全屏风格
                    // listView.contentInsetAdjustmentBehavior = .never TODO
                } else {
                    let imageView = ImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: topBarHeight))
                    imageView.image = image
                    view.addSubview(imageView)
                }
                navigationBar.setBackgroundImage(UIImage(), for: .default)
                navigationBar.shadowImage = UIImage()
                navigationBar.barStyle = .black
                navigationBar.barTintColor = nil
                navigationBar.tintColor = .white
                navigationBar.isTranslucent = true
                if showTitle {
                    navigationBar.titleTextAttributes?.removeValue(forKey: .foregroundColor)
                } else {
                    navigationBar.titleTextAttributes = [.foregroundColor: UIColor.clear]
                }
                if !hidesBottomBarWhenPushed {
                    //                if let listView = view.subviews.last as? UIScrollView { //TODO
                    //                    fixListViewHeight(listView: listView, tabBarController: tabBarController) // 解决透明导航栏时被tabBar遮挡
                    //                }
                }
            case .light:
                setNav(navigationBar)
                navigationBar.isTranslucent = false
                // iOS 11 上处理阴影线
                navigationBar.setBackgroundImage(UIImage(), for: .default)
                navigationBar.shadowImage = UIImage()
            case .lightComplete:
                setNav(navigationBar)
                navigationBar.isTranslucent = false
                navigationBar.setBackgroundImage(UIImage(), for: .default)
                navigationBar.shadowImage = UIImage()
            default: // 默认导航栏
                setNav(navigationBar)
            }
        }

        func setNav(_ navigationBar: UINavigationBar) {
            extendedLayoutIncludesOpaqueBars = true
            navigationBar.setBackgroundImage(nil, for: .default)
            navigationBar.shadowImage = nil
            navigationBar.barStyle = .default
            navigationBar.barTintColor = nil
            navigationBar.tintColor = getTheme().navigationBarTintColor
            navigationBar.isTranslucent = true
            navigationBar.titleTextAttributes = getTheme().titleTextAttributes
            navigationBar.largeTitleTextAttributes = getTheme().largeTitleTextAttributes
        }
    }

    /// 隐藏返回菜单.
    /// 1. 如果目标 Controller 需求效果不同, 放在 onSegue 中判断不同 destination 调用, 但横滑一半再返回可能出问题.
    /// 2. 如果相同, 在 viewWillAppear 调用, 不能在 onCreate中 调用, 为了实现 1, 每次在 viewWillAppear 中做了还原, 未继承 BaseController时 使用效果 1 需要手动还原.
    func setBackBarButtonItem(title: String?) {
        navigationItem.backBarButtonItem = title == nil ? nil : UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
    }

    func setToolbar(style: Theme.BarStyle) {
        switch style {
        case .transparent: // 透明工具栏
            navigationController?.toolbar.let { it in
                it.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
                it.setShadowImage(UIImage(), forToolbarPosition: .any)
                it.tintColor = .white
            }
        default:
            break
        }
    }
}
