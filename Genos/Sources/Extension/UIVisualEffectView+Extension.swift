//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

public extension UIVisualEffectView {
    func addVibrancyView() -> UIVisualEffectView {
        let vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: effect as? UIBlurEffect ?? UIBlurEffect(style: .light)))
        vibrancyView.frame = bounds
        vibrancyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(vibrancyView)
        return vibrancyView
    }
}
