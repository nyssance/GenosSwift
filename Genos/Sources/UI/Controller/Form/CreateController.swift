//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

open class CreateController<D: Decodable, T: Field, V: UITableViewCell>: FormController<D, T, V> {
    // MARK: - 👊 Genos

    public final override func onSubmit(_ parameters: [String: String]) {
        if call?.method != .post {
            showDebugAlert("创建接口建议使用POST, 目前为\(call?.method as Optional)")
        }
        create()
    }

    // MARK: - 💛 Action

    public func create() {
        // loader.create(parameters: onCreateParameters(data: data))
        call?.parameters = onCreateParameters(data: getData())
        loader?.load()
    }

    open func onCreateParameters(data: D?) -> [String: Any] {
        [:]
    }
}
