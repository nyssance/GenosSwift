//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

extension UILabel {
    @discardableResult
    public func setText(_ text: String?, fit: Bool = true) -> CGSize {
        self.text = text
        if fit {
            sizeToFit()
        }
        return frame.size
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
