//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

import GrowingTextView

open class TextViewCreate<D: Decodable, T: Field, V: UITableViewCell>: CreateController<D, T, V>, UITextViewDelegate {
    public var textView: GrowingTextView!
    var countBarButton: UIBarButtonItem!
    var copyCountB: UIBarButtonItem!
    var maxLength = 10

    // MARK: - 💖 生命周期 (Lifecycle)

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem?.isEnabled = textView.text.isNotBlank
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isToolbarHidden = true
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Modal模式下键盘应该在界面之后出来, 根据设置中iCloud改名返回时键盘在界面消失后消失无所谓
        textView.becomeFirstResponder()
    }

    // MARK: - 👊 Genos

    open override func onCreate() {
        super.onCreate()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(create))
        countBarButton = UIBarButtonItem()
        setToolbarItems([FLEXIBLE_SPACE, countBarButton], animated: false)
        // 输入框
        textView = GrowingTextView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - (navigationController?.toolbar.frame.height ?? 0)))
        // 自定义键盘栏
        copyCountB = UIBarButtonItem()
        textView.delegate = self
        view.addSubview(textView)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    open override func onDisplay(data: D) {
        super.onDisplay(data: data)
        cancel()
    }

    open func onCreate(string: String) {
        fatalError("This method must be overriden")
    }

    // MARK: - 💛 Action

    @objc
    public override func create() {
        if !isLoading {
            isLoading = true
            onCreate(string: textView.text.trimmed(set: .whitespacesAndNewlines)) // TODO: 是否精确
        }
    }

    // MARK: - 💜 UITextViewDelegate

    open func textViewDidChange(_ textView: UITextView) {
        navigationItem.rightBarButtonItem?.isEnabled = textView.text.isNotBlank
        // utf16Count不一定准确 SO https://stackoverflow.com/questions/24037711/get-the-length-of-a-string
        let textCount = maxLength - textView.text.count
        if 0...10 ~= textCount {
            countBarButton.tintColor = .gray
            countBarButton.title = "\(textCount)"
            copyCountB.tintColor = .gray
            copyCountB.title = "\(textCount)"
        } else if textCount < 0 {
            navigationItem.rightBarButtonItem?.isEnabled = false
            countBarButton.tintColor = .red
            countBarButton.title = "\(textCount)"
            copyCountB.tintColor = .red
            copyCountB.title = "\(textCount)"
        } else {
            countBarButton.title = nil
            copyCountB.title = nil
        }
    }

    // MARK: - ⌨️ 键盘

    @objc
    func keyboardWillShow(_ notification: Notification) {
        let kbSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as AnyObject).cgRectValue.size
        if let toolbarHeight = navigationController?.toolbar.frame.height {
            textView.frame.size.height = view.frame.height - kbSize.height - toolbarHeight
        }
    }

    @objc
    func keyboardWillHide(_ notification: Notification) {
        textView.frame.size.height = view.frame.height
    }
}
