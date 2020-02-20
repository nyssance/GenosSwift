//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

public class Item: BaseItem {
    public var choices: [String: String] = [:]
    public var destination: UIViewController.Type?
    public var link: String?

    public init(name: String = "", icon: UIImage? = nil, title: String? = nil, subtitle: String? = nil, destination: UIViewController.Type? = nil, link: String? = nil, enabled: Bool = false, choices: [String: String] = [:]) {
        super.init(name: name, icon: icon, title: title, subtitle: subtitle, enabled: enabled)
        self.choices = choices
        self.destination = destination
        self.link = link?.trim()
        self.enabled = enabled || self.destination != nil || self.link?.isNotBlank ?? false
    }

    public func isInternal() -> Bool {
        let link = self.link.orEmpty()
        return destination != nil || link.starts(with: APP_SCHEME) || link.starts(with: "https")
    }
}
