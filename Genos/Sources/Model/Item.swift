//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

public class Item: BaseItem {
    public var choices: [String: String] = [:]
    public var destination: UIViewController.Type?
    public var link = ""

    public init(name: String = "", icon: UIImage? = nil, title: String? = nil, subtitle: String? = nil, destination: UIViewController.Type? = nil, link: String = "", enabled: Bool = false, choices: [String: String] = [:]) {
        super.init(name: name, icon: icon, title: title, subtitle: subtitle, enabled: enabled)
        self.choices = choices
        self.destination = destination
        if link.isBlank {
            if let destination = destination {
                var str = String(describing: destination).lowercased()
                if str.hasSuffix("list") {
                    str = str.replacingOccurrences(of: "list", with: "_list")
                } else if str.hasSuffix("detail") {
                    str = str.replacingOccurrences(of: "detail", with: "_detail")
                } else if str.hasSuffix("create") {
                    str = str.replacingOccurrences(of: "create", with: "_create")
                }
                self.link = "\(APP_SCHEME)://\(str)"
            }
        } else {
            self.link = link.trimmed()
        }
        self.enabled = enabled || self.link.isNotBlank
    }
}
