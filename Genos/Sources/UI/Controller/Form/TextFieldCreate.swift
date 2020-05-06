//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

public class TextFieldCreate<D: Decodable, T: Field, V: UITableViewCell>: TextFieldForm<D, T, V> {
    // MARK: - 👊 Genos

    override public func onDisplay(data: D) {
        super.onDisplay(data: data)
        // cancel()
    }
}
