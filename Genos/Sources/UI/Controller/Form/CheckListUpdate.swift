//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

open class CheckListUpdate<D: Decodable>: SingleFieldFormController<D, Item, ItemRow> { // CheckList时候只有update, 没有create的情况
    // MARK: - 👊 Genos

    open override func onCreate() {
        super.onCreate()
        navigationItem.rightBarButtonItem = nil // 不需要右上角提交按钮
    }

    open override func onDisplayItem(item: Item, view: ItemRow, viewType: Int) {
        super.onDisplayItem(item: item, view: view, viewType: viewType)
        mirror?.let { it in
            (item.enabled, view.accessoryType) = item.name == getValue(field.name.camelCased(), mirror: it) as? String ? (false, .checkmark) : (true, .none)
        }
    }

    open override func onOpenItem(item: Item) {
        if item.enabled {
            parameters = [field.name: item.name]
            submit()
        }
    }

    open override func onSubmit(_ parameters: [String: String]) {
        super.onSubmit(parameters)
        if call?.method != .patch {
            showDebugAlert("更新接口建议使用 PATCH, 目前为 \(call?.method as Optional)")
        }
        // loader.update(parameters: parameters)
        call?.parameters = parameters
        loader?.load()
    }

    override func needDeselect(_ item: Item) -> Bool {
        true
    }
}
