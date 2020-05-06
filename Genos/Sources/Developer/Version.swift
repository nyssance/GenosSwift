//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

public class Version: TableViewDetail<String, Item, ItemRow> {
    // MARK: - 👊 Genos

    override public func onCreate() {
        title = "version".locale
        items = [
            [
                Item(name: "display_name", subtitle: InfoPlistUtil.APP_DISPLAY_NAME)
            ],
            [
                Item(name: "name", subtitle: InfoPlistUtil.APP_NAME),
                Item(name: "version_name", subtitle: InfoPlistUtil.APP_VERSION_NAME),
                Item(name: "version", subtitle: InfoPlistUtil.APP_VERSION),
                Item(name: "bundle_identifier", subtitle: InfoPlistUtil.APP_BUNDLE_IDENTIFIER)
            ]
        ]
    }
}
