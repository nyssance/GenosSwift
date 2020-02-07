//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

public enum SubmitButtonType: Int, CaseIterable {
    case button, navigation
}

open class FormController<D: Decodable, T: BaseItem, V: UITableViewCell>: GroupedTableViewController<D, T, V> {
    public var submitButton: UIButton!
    public var submitButtonType = SubmitButtonType.button

    public var parameters: [String: String] = [:]

    // MARK: - 👊 Genos

    open override func onCreate() {
        refreshMode = .never // 表单页默认不刷新
        submitButton = QuickButton(controller: self, y: getTheme().padding, title: "submit".locale, action: #selector(submit))
        if submitButtonType == .navigation {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(submit)) // 右上完成按钮
            navigationItem.rightBarButtonItem?.isEnabled = false
            NotificationCenter.default.addObserver(self, selector: #selector(enable), name: UITextField.textDidChangeNotification, object: nil)
        }
    }

    // MARK: - 💛 Action

    @objc
    public final func submit() { // 提交
        func validated() -> Bool {
            let pre = onPreValiate(allowsAlert: true)
            if pre.0 { // 为了安全提交的时候预检还是做一遍, 且弹框
                return onValidate(pre.parameters)
            }
            return false
        }

        if isLoading {
            showAlert("不要重复提交")
        } else {
            if validated() {
                isLoading = true
                onSubmit(parameters)
            }
        }
    }

    @objc
    func enable() { // 菜单有效
    }

    /// 预检, 用于判断按钮状态, 一般不弹框.
    open func onPreValiate(allowsAlert: Bool) -> (Bool, parameters: [String: String]) {
        (true, [:])
    }

    /// 提交后的检查, 弹框.
    open func onValidate(_ parameters: [String: String]) -> Bool {
        true
    }

    /// 提交, 不要再在里面做检查, 会导致 isLoading 状态不正确.
    open func onSubmit(_ parameters: [String: String]) {
        call?.parameters = parameters
        loader?.load()
    }
}
