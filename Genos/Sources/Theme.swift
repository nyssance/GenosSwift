//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

open class Theme {
    public enum BarStyle: Int, CaseIterable {
        case `default`, light, lightComplete, transparent, colorful
    }

    // 颜色
    public var colorPrimary = UIColor.colorWithHex(APP_COLOR)
    public var colorPrimaryDark = UIColor.colorWithHex(APP_COLOR)
    public var colorAccent = UIColor.colorWithHex(APP_COLOR)
    // 背景色
    public var colorBackground: UIColor? // 系统默认应该是 0xF5F5F5
    public var colorListSelector: UIColor?
    // 字体, 字号, 字色
    public var textFontPrimary: UIFont?
    public var textColorPrimary: UIColor? // 系统默认应该是 UIColor.black
    public var textFontSecondary: UIFont?
    public var textColorSecondary: UIColor?
    public var sectionheaderFont: UIFont?
    // 导航栏
    public var navigationBarStyle = BarStyle.default
    public var navigationBarTintColor: UIColor!
    public var navigationBarProgressTintColor: UIColor!
    public var backItemStyle: String? // 返回按钮样式
    // 导航栏 :: 标题，大标题
    public var prefersLargeTitles = true // 默认大标题
    public var titleTextAttributes: [NSAttributedString.Key: Any]?
    public var largeTitleFont: UIFont?
    public var largeTitleTextAttributes: [NSAttributedString.Key: Any]?
    // 边距
    public var padding: CGFloat = IS_IPHONE_PLUS || IS_IPHONE_XS_MAX ? 20 : 15 // 60px 30px 究竟是15还是16
    public var paddingInner: CGFloat = IS_IPHONE_PLUS || IS_IPHONE_XS_MAX ? 20 : 15
    public var buttonHeight: CGFloat = 45
    // 单元格
    public var tableViewRowHeight: CGFloat = 44 // iOS 9 以后究竟是45还是44 (连分割线是45)
    public var tableCellFont: UIFont? // 不设置就为默认值
    public var tableCellTextColor: UIColor?
    public var tableCellDetailFont: UIFont?
    public var tableCellDetailTextColor: UIColor?
    // 暂时
    public var rowHeightBig: CGFloat = 80
    public var GROUP_TABLE_BOTTOM_HEIGHT: CGFloat = 27.5

    public init() {
        navigationBarTintColor = colorPrimary
        navigationBarProgressTintColor = colorPrimary
        if let color = textColorPrimary {
            titleTextAttributes = [.foregroundColor: color]
        }
    }
}
