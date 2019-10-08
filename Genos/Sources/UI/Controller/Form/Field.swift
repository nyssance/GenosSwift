//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

public class BaseItem {
    public var name = ""
    public var icon: UIImage?
    public var title = ""
    public var subtitle: String?
    public var enabled = false

    public var indexPath: IndexPath?
    public var tag = 0

    public class var emptyItem: Item {
        return Item()
    }

    public init(name: String, icon: UIImage? = nil, title: String? = nil, subtitle: String? = nil, enabled: Bool = false) {
        self.name = name
        self.icon = icon
        self.title = title ?? name.locale
        self.subtitle = subtitle
        self.enabled = enabled
    }
}

public class Field: BaseItem {
    public var minLength = 1
    public var maxLength = 30
    public var placeholder = ""

    public init(name: String, icon: UIImage? = nil, title: String? = nil, enabled: Bool = true, placeholder: String? = nil, minLength: Int = 1, maxLength: Int = 30) {
        super.init(name: name, icon: icon, title: title, enabled: enabled)
        self.placeholder = placeholder ?? self.title
        self.minLength = minLength
        self.maxLength = maxLength
    }
}

public class CharField: Field {
    public override init(name: String, icon: UIImage? = nil, title: String? = nil, enabled: Bool = true, placeholder: String? = nil, minLength: Int = 1, maxLength: Int = 30) {
        super.init(name: name, icon: icon, title: title, enabled: enabled, placeholder: placeholder, minLength: minLength, maxLength: maxLength)
    }
}

public class NumberField: Field {
    public var minValue = 0
    public var maxValue = Int.max

    public init(name: String, icon: UIImage? = nil, title: String? = nil, enabled: Bool = true, placeholder: String? = nil, minLength: Int = 1, maxLength: Int = 10, minValue: Int = 0, maxValue: Int = Int.max) {
        super.init(name: name, icon: icon, title: title, enabled: enabled, placeholder: placeholder, minLength: minLength, maxLength: maxLength)
        self.minValue = minValue
        self.maxValue = maxValue
    }
}

public class DecimalField: CharField {
    public var minValue: Double = 0
    public var maxValue: Double = 1_000_000_000

    public init(name: String, icon: UIImage? = nil, title: String? = nil, enabled: Bool = true, placeholder: String? = nil, minLength: Int = 1, maxLength: Int = 12, minValue: Double = 0, maxValue: Double = 1_000_000_000) {
        super.init(name: name, icon: icon, title: title, enabled: enabled, placeholder: placeholder, minLength: minLength, maxLength: maxLength)
        self.minValue = minValue
        self.maxValue = maxValue
    }
}

public class PasswordField: CharField {
    public init(icon: UIImage? = nil, title: String? = nil, placeholder: String? = nil, minLength: Int = 6, maxLength: Int = 30) {
        super.init(name: "password", icon: icon, title: title, placeholder: placeholder, minLength: minLength, maxLength: maxLength)
    }
}
