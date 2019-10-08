//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

extension UIVisualEffectView {
    public func addVibrancyView() -> UIVisualEffectView {
        let vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: effect as? UIBlurEffect ?? UIBlurEffect(style: .light)))
        vibrancyView.frame = bounds
        vibrancyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(vibrancyView)
        return vibrancyView
    }
}
