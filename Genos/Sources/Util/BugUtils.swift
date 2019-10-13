//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

// import PureLayout

public struct BugUtils {
    // public static func getBottomButton(controller: UIViewController, title: String?, action: Selector) -> UIButton {
    //    let frame = controller.view.frame
    //    let button = QuickButton(frame: CGRect(x: 0, y: frame.height - APP_THEME.tableViewRowHeight, width: frame.width, height: APP_THEME.tableViewRowHeight), title: title, target: controller, action: action, theme: STYLE_BUTTON_DARK)
    //    button.layer.cornerRadius = 0
    //    return button
    // }

    // iOS8 ?
    // static func fixListViewHeight(listView: UIScrollView, tabBarController: UITabBarController) {
    //    listView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 0, bottom: tabBarController.tabBar.frame.height, right: 0))
    // }

    // 文字自适应size //TODO 临时
    public static func getTextSize(_ text: String, font: UIFont, width: CGFloat = SCREEN_WIDTH - 2 * APP_THEME.padding) -> CGSize {
        (text as NSString).boundingRect(with: CGSize(width: width, height: CGFloat(HUGE)), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).size
    }
}
