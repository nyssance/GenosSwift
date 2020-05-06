//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

open class TextFieldRow: UITableViewCell {
    public var textField: UITextField!

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        textLabel?.isHidden = true
        textField = UITextField(frame: CGRect(x: APP_THEME.padding, y: 0, width: frame.width - 2 * APP_THEME.padding, height: frame.height))
        textField.font = detailTextLabel?.font
        //
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .next
        addSubview(textField)
        // TODO: highlight不可选
    }
}
