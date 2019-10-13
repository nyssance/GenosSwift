//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

// SO https://stackoverflow.com/questions/1214965/setting-action-for-back-button-in-navigation-controller/19132881#comment34452906_19132881
public protocol BackBarButtonItemDelegate {
    func shouldPopOnBackBarButtonItem() -> Bool
}

extension UINavigationController: UINavigationBarDelegate {
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if viewControllers.count < navigationBar.items?.count ?? 2 {
            return true
        }
        var shouldPop = true
        if let viewController = topViewController as? BackBarButtonItemDelegate {
            shouldPop = viewController.shouldPopOnBackBarButtonItem()
        }
        if shouldPop {
            DispatchQueue.main.async {
                self.popViewController(animated: true)
            }
        } else {
            // Prevent the back button from staying in an disabled state
            for view in navigationBar.subviews where view.alpha < 1 {
                UIView.animate(withDuration: 0.25, animations: {
                    view.alpha = 1
                })
            }
        }
        return false
    }

    @discardableResult
    public func popTo(_ viewController: UIViewController.Type) -> Bool {
        for controller in viewControllers {
            if controller.isMember(of: viewController.self) {
                popToViewController(controller, animated: true)
                return true
            }
        }
        return false
    }
}
