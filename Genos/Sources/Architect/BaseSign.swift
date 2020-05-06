//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

open class BaseSign<D: Decodable, V: UITableViewCell>: TextFieldForm<D, Field, V> {
    // MARK: - 👊 Genos

    override open func onCreate() {
        super.onCreate()
        items = [
            [
                CharField(name: "username"),
                PasswordField()
            ]
        ]
    }

    override open func onViewCreated() {
        super.onViewCreated()
        textFields.first?.resignFirstResponder()
    }

    override open func onDisplay(data: D) {
        super.onDisplay(data: data)
        onAuthorized(data)
    }

    //
    open func onAuthorized(_ data: D) {
        showAlert("登录成功, 请覆写 onDataLoadSuccess 处理收到的数据, 比如 ```updateUser(user) cancel()```")
    }
}
