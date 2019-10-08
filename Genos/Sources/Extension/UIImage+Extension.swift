//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

extension UIImage {
    /// 空白图片.
    public class var emptyImage: UIImage? {
        return image(withColor: .colorWithHex(0xFFFFFF, alpha: 0))
    }

    /// 缩放.
    public func resize(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        draw(in: CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    /// 切图.
    public func crop(rect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        draw(at: CGPoint(x: -rect.origin.x, y: -rect.origin.y))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    /// 生成纯色图片, 默认大小1x1, 在 UITableViewCell 默认左侧图标使用时需要手动设定大小占位.
    public class func image(withColor color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        color.set()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
