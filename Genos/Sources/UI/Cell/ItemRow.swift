//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

open class ItemRow: UITableViewCell {
    public var badge: UILabel!

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // TODO: getCurrentController.getTheme
        textLabel?.font = APP_THEME.rowFont
        textLabel?.textColor = APP_THEME.rowTextColor
        detailTextLabel?.font = APP_THEME.rowDetailFont
        detailTextLabel?.textColor = APP_THEME.rowDetailTextColor
        if let color = APP_THEME.colorListSelector {
            let view = UIView()
            view.backgroundColor = color
            selectedBackgroundView = view
        }
        badge = UILabel(frame: CGRect(x: SCREEN_WIDTH - 3 * APP_THEME.padding, y: frame.height / 2 - 5, width: 10, height: 10))
        badge.backgroundColor = .red
        badge.layer.cornerRadius = 5
        badge.layer.masksToBounds = true
        addSubview(badge)
        badge.isHidden = true
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        badge.frame.origin.x = (textLabel?.frame.maxX ?? 2 * APP_THEME.padding) + 8
    }

    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        badge.backgroundColor = .red
    }

    open override var isHighlighted: Bool {
        didSet {
            badge.backgroundColor = .red
        }
    }
}
