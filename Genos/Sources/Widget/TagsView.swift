//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

public class TagsView: UIView {
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public func setTags(_ tags: [String], target: Any?, action: Selector) {
        func getBtn(title: String, width: CGFloat) -> UIButton {
            let btn = UIButton()
            btn.setTitle(title, for: [])
            btn.setTitleColor(APP_THEME.colorPrimary, for: [])
            btn.titleLabel?.font = .systemFont
            btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            btn.sizeToFit()
            btn.layer.cornerRadius = 13
            btn.layer.borderColor = APP_THEME.colorPrimary.cgColor
            btn.layer.borderWidth = 1
            btn.frame.size.height = 28
            if btn.frame.width > width {
                btn.frame.size.width = width
            }
            return btn
        }

        var x = APP_THEME.padding // 左边距
        var y: CGFloat = 10 // 上边距10
        tags.forEach { it in
            let btn = getBtn(title: it, width: frame.width - 32)
            if x + btn.frame.width + 16 + 10 > frame.width {
                x = APP_THEME.padding
                y += btn.frame.height + 10
            }
            btn.frame.origin = CGPoint(x: x, y: y)
            x += btn.frame.width + 10
            addSubview(btn)
            btn.addTarget(target, action: action, for: .touchUpInside)
        }
        frame.size.height = y + 28 + 10 // 行高28 下边距10
    }
}
