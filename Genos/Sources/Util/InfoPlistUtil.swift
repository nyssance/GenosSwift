//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

public struct InfoPlistUtil {
    public static let APP_DISPLAY_NAME = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "" // 用infoDictionary取不到
    public static let APP_NAME = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
    public static let APP_VERSION = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    public static let APP_VERSION_NAME = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    public static let APP_BUNDLE_IDENTIFIER = Bundle.main.bundleIdentifier ?? ""

    // 用于获取三方SDK的app_id
    public static func getURLScheme(_ name: String) -> String? {
        if let URLTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [[String: Any]] {
            for URLType in URLTypes {
                if let URLName = URLType["CFBundleURLName"] as? String, URLName == name {
                    if let URLSchemes = URLType["CFBundleURLSchemes"] as? [String] {
                        return URLSchemes.first
                    }
                }
            }
        }
        return nil
    }
}
