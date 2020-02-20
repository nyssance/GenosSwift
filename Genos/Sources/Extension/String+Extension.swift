//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

extension Optional where Wrapped == String {
    func orEmpty() -> String {
        switch self {
        case let .some(value):
            return String(describing: value)
        case _:
            return ""
        }
    }
}

public extension String {
    func trim(set: CharacterSet = .whitespaces) -> String {
        trimmingCharacters(in: set)
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
    func camelCased(separator: String = "_") -> String {
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
    func underscored() -> String { // TODO: 待优化
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

    func pluralize() -> String {
        "\(self)s"
    }

    func singularize() -> String {
        String(prefix(count - 1))
    }

    func removePrefix(_ prefix: String) -> String {
        hasPrefix(prefix) ? String(dropFirst(prefix.count)) : self
    }

    func removeSuffix(_ suffix: String) -> String {
        hasSuffix(suffix) ? String(dropLast(suffix.count)) : self
    }

    var locale: String { Util.localizedString(self) }

    var localeSystem: String { // Bundle(for: UIButton.self) 也可
        if let bundle = Bundle(identifier: "com.apple.UIKit") {
            return NSLocalizedString(self, bundle: bundle, comment: "")
        }
        return self
    }

    var isBlank: Bool { trim().isEmpty }

    var isNotBlank: Bool { !isBlank }

    /// 计算字符串高度.
    func size(width: Double, font: UIFont) -> CGSize {
        self.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).size
    }

    func size(font: UIFont) -> CGSize {
        size(width: .greatestFiniteMagnitude, font: font)
    }
}
