//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

public struct InfoPlistUtil {
    public static let APP_DISPLAY_NAME = (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String).orEmpty() // 用infoDictionary取不到
    // <https://itunes.apple.com/cn/app/:APP_ID>
    public static let APP_ID = (Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String).orEmpty()
    public static let APP_NAME = (Bundle.main.infoDictionary?["CFBundleName"] as? String).orEmpty()
    public static let APP_VERSION = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String).orEmpty()
    public static let APP_VERSION_NAME = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String).orEmpty()
    public static let APP_BUNDLE_IDENTIFIER = Bundle.main.bundleIdentifier.orEmpty()

    // 用于获取三方SDK的app_id
    public static func getURLScheme(_ name: String) -> String? {
        if let schemes = (Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [[String: Any]])?.first(where: { ($0["CFBundleURLName"] as? String) == name })?["CFBundleURLSchemes"] as? [String] {
            return schemes.first
        }
        return nil
    }
}
