//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

open class TextFieldUpdate<D: Decodable, T: Field, V: UITableViewCell>: TextFieldForm<D, T, V> {
    // MARK: - 👊 Genos

    override open func onDisplay(data: D) {
        super.onDisplay(data: data)
        cancel()
    }

    override open func onSubmit(_ parameters: Parameters) {
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
