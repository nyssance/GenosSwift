//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

import SwiftyUserDefaults

public class Developer: TableViewDetail<String, Item, ItemRow> {
    // MARK: - 👊 Genos

    public override func onCreate() {
        setNavigationBar(style: .default, from: "developer")
        items = [
            //            [
            //                Item(name: "url", subtitle: BASE_URL)
            //            ],
            [
                Item(name: "test_env", title: "测试环境"),
                Item(name: "debug"),
                Item(name: "version", link: "\(APP_SCHEME)://version")
            ]
        ]
    }

    open override func onDisplayItem(item: Item, view: ItemRow, viewType: Int) {
        super.onDisplayItem(item: item, view: view, viewType: viewType)
        switch item.name {
        case "debug":
            let switchView = UISwitch().apply { it in
                it.isOn = Defaults[.debug]
                it.addTarget(self, action: #selector(debug(sender:)), for: .valueChanged)
            }
            view.accessoryView = switchView
        case "test_env":
            let switchView = UISwitch().apply { it in
                it.isOn = Defaults[.test_env]
                it.addTarget(self, action: #selector(testEnv(sender:)), for: .valueChanged)
            }
            view.accessoryView = switchView
        default:
            break
        }
    }

    public override func onOpenItem(item: Item) {
        switch item.name {
        case "version":
            navigateTo(Version())
        default:
            break
        }
    }

    // MARK: - 💛 Action

    @objc
    func debug(sender: UISwitch) {
        Defaults[.debug] = sender.isOn
        isDebug = sender.isOn
    }

    @objc
    func testEnv(sender: UISwitch) { // 切换用户做清理
        // FIXME: 需要手动处理用户退出
        Defaults[.test_env] = sender.isOn
        // APP_MANAGER.loadSettings()
        exit(0) // 强行关闭app的方法(0正常退出, 1异常退出)
    }
}
