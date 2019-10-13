//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

public extension UILabel {
    @discardableResult
    func setText(_ text: String?, fit: Bool = true) -> CGSize {
        self.text = text
        if fit {
            sizeToFit()
        }
        return frame.size
    }

    @discardableResult
    func setAttributedText(_ text: NSAttributedString, fit: Bool = true) -> CGSize {
        attributedText = text
        if fit {
            sizeToFit()
        }
        return frame.size
    }
}
