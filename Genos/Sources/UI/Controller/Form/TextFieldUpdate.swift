//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

import Alamofire

open class TextFieldUpdate<D: Decodable, T: Field, V: UITableViewCell>: TextFieldForm<D, T, V> {
    // MARK: - 👊 Genos

    open override func onDisplay(data: D) {
        super.onDisplay(data: data)
        cancel()
    }

    open override func onSubmit(_ parameters: Parameters) {
        super.onSubmit(parameters)
        if textFields.count == 1, originalText == textFields.first?.text { // 字符串没变化不提交
            cancel()
        } else {
            // loader.update(parameters: parameters)
            call?.parameters = parameters
            loader?.load()
        }
    }
}
