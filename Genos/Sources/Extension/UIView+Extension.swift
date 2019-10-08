//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

extension UIView {
    /// 获取 View 的快照, 使用时注意四舍五入问题避免白边.
    public func getSnapshot(scale: CGFloat = 0) -> UIImage? { // 0等同UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale)
        // layer.renderInContext(UIGraphicsGetCurrentContext()) // iOS9真机上会无法保存
        drawHierarchy(in: bounds, afterScreenUpdates: true) // 号称速度快, 但连续绘制会丢图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
