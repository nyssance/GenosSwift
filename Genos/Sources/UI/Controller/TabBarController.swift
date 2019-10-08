//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

open class TabBarController: UITabBarController, UITabBarControllerDelegate {
    public var controllers: [UIViewController] = []

    // MARK: - 💖 生命周期 (Lifecycle)

    public final override func loadView() {
        super.loadView()
        onCreate()
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        tabBar.tintColor = APP_THEME.colorPrimary
        controllers.forEach { it in
            onAppend(it)
        }
    }

    open func onCreate() {
        fatalError("这个方法必须被覆盖")
    }

    open func onAppend(_ controller: UIViewController) {
        let name = "\(controller.classForCoder)".underscored()
        append(controller, title: name.locale, image: UIImage(named: "ic_tab_\(name)"), selectedImage: UIImage(named: "ic_tab_\(name)_highlighted"))
    }

    public final func append(_ controller: UIViewController, title: String? = nil, image: UIImage? = nil, selectedImage: UIImage? = nil) {
        controller.tabBarItem.title = title
        controller.tabBarItem.image = image
        controller.tabBarItem.selectedImage = selectedImage
        addChild(UINavigationController(rootViewController: controller))
    }
}
