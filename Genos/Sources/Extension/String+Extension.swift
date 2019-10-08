//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

extension String {
    public func trimmed(set: CharacterSet = .whitespaces) -> String {
        return trimmingCharacters(in: set)
    }

    /// Returns a camel case version of the string.
    ///
    /// The following example transforms a string to camel case letters:
    ///
    ///     let cafe = "café_cup 🍵"
    ///     print(cafe.camelCased())
    ///     // Prints "CaféCup 🍵"
    ///
    /// - Returns: A camel case copy of the string.
    ///
    /// - Complexity: O(*n*)
    public func camelCased(separator: String = "_") -> String {
        if isBlank {
            return self
        }
        var rest = capitalized.replacingOccurrences(of: separator, with: "")
        rest.remove(at: startIndex)
        return "\(String(describing: first))\(rest)"
    }

    /// Returns an underscore version of the string.
    ///
    /// The following example transforms a string to underscore letters:
    ///
    ///     let cafe = "CaféCup 🍵"
    ///     print(cafe.underscored())
    ///     // Prints "café_cup 🍵"
    ///
    /// - Returns: An underscore copy of the string.
    ///
    /// - Complexity: O(*n*)
    public func underscored() -> String { // TODO: 待优化
        var s = ""
        enumerated().forEach { offset, element in
            let str = String(element)
            if offset == 0 { // 首字母
                s += str.lowercased()
            } else {
                if str == str.lowercased() {
                    s += str
                } else {
                    s += "_\(str.lowercased())"
                }
            }
        }
        return s
    }

    public var locale: String {
        return Utils.localizedString(self)
    }

    public var localeSystem: String { // Bundle(for: UIButton.self) 也可
        if let bundle = Bundle(identifier: "com.apple.UIKit") {
            return NSLocalizedString(self, bundle: bundle, comment: "")
        }
        return self
    }

    public var isBlank: Bool {
        return trimmed().isEmpty
    }

    public var isNotBlank: Bool {
        return !isBlank
    }
}
