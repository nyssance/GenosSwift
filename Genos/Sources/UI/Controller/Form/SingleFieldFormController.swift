//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

open class SingleFieldFormController<D: Decodable, T: BaseItem, V: UITableViewCell>: FormController<D, T, V> {
    public var field: Field!

    // MARK: - 👊 Genos
}

open class SingleTextFieldForm<D: Decodable, T: Field, V: UITableViewCell>: SingleFieldFormController<D, T, V> {}
