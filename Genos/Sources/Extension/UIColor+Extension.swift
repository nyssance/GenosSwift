//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

extension UIColor {
    // Apple https://developer.apple.com/ios/human-interface-guidelines/visual-design/color/
    // 命名为 systemBlue systemRed 会覆盖系统 class var, 利用该特性可以方便的替换系统颜色

    /// 16进制颜色.
    public static func colorWithHex(_ hexColor: Int, alpha: CGFloat = 1) -> UIColor {
        UIColor(
            red: CGFloat((hexColor & 0xFF0000) >> 16) / 255,
            green: CGFloat((hexColor & 0xFF00) >> 8) / 255,
            blue: CGFloat(hexColor & 0xFF) / 255,
            alpha: alpha
        )
    }
}
