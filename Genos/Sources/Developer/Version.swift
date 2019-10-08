//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

public class Version: TableViewDetail<String, Item, ItemCell> {
    // MARK: - 👊 Genos

    public override func onCreate() {
        title = "version".locale
        items = [
            [
                Item(name: "display_name", subtitle: InfoPlistUtils.APP_DISPLAY_NAME)
            ],
            [
                Item(name: "name", subtitle: InfoPlistUtils.APP_NAME),
                Item(name: "version_name", subtitle: InfoPlistUtils.APP_VERSION_NAME),
                Item(name: "version", subtitle: InfoPlistUtils.APP_VERSION),
                Item(name: "bundle_identifier", subtitle: InfoPlistUtils.APP_BUNDLE_IDENTIFIER)
            ]
        ]
    }
}
