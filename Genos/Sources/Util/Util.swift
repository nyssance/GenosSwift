//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

public struct Util {
    public static func iOS(min: String, max: String = "14.0") -> Bool {
        let version = UIDevice.current.systemVersion
        return (min.compare(version, options: .numeric) == .orderedAscending || min.compare(version, options: .numeric) == .orderedSame) && (max.compare(version, options: .numeric) == .orderedDescending || max.compare(version, options: .numeric) == .orderedSame)
    }

    public static func appLink(id: String) -> String {
        "itms-apps://itunes.apple.com/app/id\(id)"
    }

    public static func appReviewsLink(id: String = APP_ID) -> String {
        "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=\(id)"
    }

    // 多语言
    public static func localizedString(_ key: String) -> String {
        if let path = Bundle(for: BaseController.self).path(forResource: "Genos", ofType: "bundle"), let bundle = Bundle(path: path) {
            let value = NSLocalizedString(key, comment: "")
            return key != value ? value : NSLocalizedString(key, bundle: bundle, comment: "")
        }
        return key
    }

    // 网络
    public static func getPage(_ path: String, parameters: Parameters = [:]) -> String {
        getUrl("\(BASE_URL)/\(path)/", parameters: parameters)
    }

    public static func getUrl(_ url: String, parameters: Parameters) -> String {
        var i = 0
        var urlString = url
        parameters.forEach { key, value in
            let separator = i == 0 ? "?" : "&"
            urlString.append("\(separator)\(key)=\(value)")
            i += 1
        }
        return urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlString // Encoding
    }

    //
    public static func getProperties(for mirror: Mirror, className: String? = nil) -> [String: Any] {
        var dict: [String: Any] = [:]

        let method = {
            mirror.children.forEach { it in
                if let label = it.label {
                    dict[label] = it.value
                }
            }
        }

        if let cls = className {
            if mirror.description.contains(cls) {
                method()
                return dict
            }
        } else {
            method()
        }
        if let parent = mirror.superclassMirror {
            getProperties(for: parent, className: className).forEach { label, value in
                dict[label] = value
            }
        }
        return dict
    }
}
