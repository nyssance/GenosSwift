//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

extension UIColor {
    // 命名为 systemBlueColor() systemRedColor() 会覆盖系统隐藏方法, 利用该特性可以方便的替换系统颜色
    public class var systemDefault: UIColor { iOSBlue }

    public class var systemDestructive: UIColor { iOSRed }

    // Apple: https://developer.apple.com/ios/human-interface-guidelines/visual-design/color/
    public class var iOSRed: UIColor { colorWithHex(0xFF3B30) }

    public class var iOSOrange: UIColor { colorWithHex(0xFF9500) }

    public class var iOSYellow: UIColor { colorWithHex(0xFFCC00) }

    public class var iOSGreen: UIColor { colorWithHex(0x4CD964) }

    public class var iOSTealBlue: UIColor { colorWithHex(0x5AC8FA) }

    public class var iOSBlue: UIColor { colorWithHex(0x007AFF) }

    public class var iOSPurple: UIColor { colorWithHex(0x5856D6) }

    public class var iOSPink: UIColor { colorWithHex(0xFF2D55) }

    /// 16进制颜色.
    public class func colorWithHex(_ hexColor: Int, alpha: CGFloat = 1) -> UIColor {
        UIColor(
            red: CGFloat((hexColor & 0xFF0000) >> 16) / 255,
            green: CGFloat((hexColor & 0xFF00) >> 8) / 255,
            blue: CGFloat(hexColor & 0xFF) / 255,
            alpha: alpha
        )
    }
}
