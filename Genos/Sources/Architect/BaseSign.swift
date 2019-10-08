//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

open class BaseSign<D: Decodable, V: UITableViewCell>: TextFieldForm<D, Field, V> {
    // MARK: - 🐤 Taylor

    open override func onCreate() {
        super.onCreate()
        items = [
            [
                CharField(name: "username"),
                PasswordField()
            ]
        ]
    }

    open override func onViewCreated() {
        super.onViewCreated()
        textFields.first?.resignFirstResponder()
    }

    open override func onDisplay(data: D) {
        super.onDisplay(data: data)
        onAuthorized(data)
    }

    //
    open func onAuthorized(_ data: D) {
        showAlert(self, message: "登录成功, 请覆写 onDataLoadSuccess 处理收到的数据, 比如 ```updateUser(user) cancel()```")
    }
}
