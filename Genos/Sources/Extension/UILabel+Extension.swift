//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

extension UILabel {
    /// 计算字符串高度.
    public func size(string: String, width: Double) -> CGSize {
        NSString(string: string).boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).size
    }

    public func size(string: String) -> CGSize {
        size(string: string, width: .greatestFiniteMagnitude)
    }

    @discardableResult
    public func setText(_ text: String?, fit: Bool = true) -> CGRect {
        self.text = text
        if fit {
            sizeToFit()
        }
        return frame
    }

    @discardableResult
    public func setAttributedText(_ text: NSAttributedString, fit: Bool = true) -> CGSize {
        attributedText = text
        if fit {
            sizeToFit()
        }
        return frame.size
    }
}
