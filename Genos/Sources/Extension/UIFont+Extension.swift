//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

extension UIFont {
    public class var labelFont: UIFont { // 17
        return systemFont(ofSize: labelFontSize)
    }

    public class var systemFont: UIFont { // 14
        return systemFont(ofSize: systemFontSize)
    }

    public class var smallSystemFont: UIFont { // 12
        return systemFont(ofSize: smallSystemFontSize)
    }
}
