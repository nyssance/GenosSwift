//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

open class TextFieldForm<D: Decodable, T: Field, V: UITableViewCell>: FormController<D, T, V>, UITextFieldDelegate, UIGestureRecognizerDelegate {
    public var textFields: [UITextField] = []
    var originalText = "" // 暂存用来判断是否重复

    var tapGesture: UITapGestureRecognizer!

    // MARK: - 💖 生命周期 (Lifecycle)

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(false) // 放在这里保证横滑键盘消失体验一致
    }

    // MARK: - 👊 Genos

    override func onCreateView() {
        super.onCreateView()
        adapter.getCurrentList().enumerated().forEach { i, field in
            let textField = field is PasswordField ? PasswordTextField() : UITextField()
            textField.placeholder = field.placeholder
            // 初始化
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            textField.clearButtonMode = .whileEditing
            textField.returnKeyType = .next
            //
            switch field {
            case is NumberField:
                textField.keyboardType = .numberPad
            case is DecimalField:
                textField.keyboardType = .decimalPad
            default:
                break
            }
            field.tag = i
            textField.tag = i // 定位
            textField.delegate = self
            if let mirror = mirror {
                textField.text = getValue(field.name.camelCased(), mirror: mirror) as? String
            }
            originalText = textField.text ?? ""
            textFields.append(textField)
        }
        textFields.first?.becomeFirstResponder()
        textFields.last?.returnKeyType = .done
    }

    open override func onViewCreated() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        tapGesture.delegate = self
        tapGesture.isEnabled = false
        listView.addGestureRecognizer(tapGesture)
        if submitButtonType == .button {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: listView.frame.width, height: submitButton.frame.height + getTheme().padding * 2))
            footerView.addSubview(submitButton)
            listView.tableFooterView = footerView
        }
    }

    open override func onDisplayItem(item: T, view: V, viewType: Int) {
        super.onDisplayItem(item: item, view: view, viewType: viewType)
        view.textLabel?.isHidden = true
        let textField = textFields[item.tag]
        textField.frame = CGRect(x: getTheme().padding, y: 0, width: view.frame.width - 2 * getTheme().padding, height: view.frame.height)
        textField.font = view.detailTextLabel?.font
        textField.textColor = view.textLabel?.textColor
        view.addSubview(textField)
        // TODO: highlight不可选
    }

    final override func enable() {
        navigationItem.rightBarButtonItem?.isEnabled = onPreValiate(allowsAlert: false).0
        // TODO: 1. 键盘return也可以设为disabled 2. 增加长度检查
    }

    open override func onPreValiate(allowsAlert: Bool) -> (Bool, parameters: [String: String]) {
//        adapter.getCurrentList().enumerated().forEach { i, field in
        for (i, field) in adapter.getCurrentList().enumerated() {
            let value = textFields[i].text?.trimmed() ?? ""
            guard value.count >= field.minLength else {
                if allowsAlert {
                    let message = value.isBlank ? Utils.localizedString("不能为空") : Utils.localizedString("至少\(field.minLength)位")
                    showAlert(self, message: "\(field.title) \(message)")
                }
                parameters = [:] // 清空
                return (false, parameters)
            }
            parameters[field.name] = value // 这样处理可以保证显示字段和实际字段不同
        }
        return (true, parameters)
    }

    open override func onSubmit(_ parameters: [String: String]) {
        textFields.forEach { it in
            it.text = it.text?.trimmed() // 提交前trim, 边输入边trim中文会有问题
        }
        view.endEditing(false) // 参考官方, 更新前先关闭键盘
        super.onSubmit(parameters)
    }

    // MARK: - 🔹 UITextFieldDelegate

    public final func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        tapGesture.isEnabled = true
        return true
    }

    public final func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        tapGesture.isEnabled = false
        return true
    }

    public final func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // SO https://stackoverflow.com/questions/433337/set-the-maximum-character-length-of-a-uitextfield
        let length = textField.text?.count ?? 0
        // if range.length + range.location > length {
        //     return false
        // } // FIXME: 这段加了Emoji计算长度出错（Swift 4可能已解决，待验证）, 另外中文拼音超出实际未超无法输入问题待解决
        return length + string.count - range.length <= adapter.getItem(IndexPath(row: textField.tag, section: 0)).maxLength
    }

    public final func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let next = view.viewWithTag(textField.tag + 1) {
            next.becomeFirstResponder()
        } else {
            submit()
        }
        return false
    }

    // MARK: - 💛 Action

    @objc
    func tap() {
        textFields.forEach { it in
            it.resignFirstResponder()
        }
    }
}
