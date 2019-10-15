//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

public class QuickButton: UIButton {
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public convenience init(controller: UIViewController, y: CGFloat, title: String?, action: Selector, isPrimary: Bool = true) {
        self.init(frame: CGRect(x: APP_THEME.padding, y: y, width: controller.view.frame.width - APP_THEME.padding * 2, height: APP_THEME.buttonHeight), title: title, target: controller, action: action, isPrimary: isPrimary)
    }

    public init(frame: CGRect, title: String?, target: Any?, action: Selector, isPrimary: Bool) {
        super.init(frame: frame)
        if isPrimary {
            backgroundColor = APP_THEME.colorPrimary
        } else {
            backgroundColor = .white
            layer.borderWidth = 1
            layer.borderColor = APP_THEME.colorPrimary.cgColor
        }
        clipsToBounds = true
        layer.cornerRadius = 3
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        setTitleColor(isPrimary ? .white : APP_THEME.colorPrimary, for: .normal)
        setTitleColor((isPrimary ? UIColor.white : APP_THEME.colorPrimary).withAlphaComponent(0.5), for: .selected)
        setTitleColor((isPrimary ? UIColor.white : APP_THEME.colorPrimary).withAlphaComponent(0.5), for: [.selected, .highlighted])
        // disabled
        setBackgroundImage(.image(withColor: .colorWithHex(0xC0C0C0)), for: .disabled)
        setTitleColor(.white, for: .disabled)
        // highlighted TODO
        //        setBackgroundImage(.imageWithColor(color: hexColor(hexColor: theme.color).darkenByPercentage(0.1)), for: .highlighted)
        setTitleColor(.white, for: .highlighted)
        // action
        addTarget(target, action: action, for: .touchUpInside)
    }
}
