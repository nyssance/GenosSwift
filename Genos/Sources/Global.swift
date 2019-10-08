//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

import SwiftyUserDefaults

public var BASE_URL = "https://www.必填.com"

public var APP_ID = "必填"
public var APP_COLOR = 0x007AFF
public var APP_SCHEME = "genos"

public var AUTH_HEADER = "Authorization"
public var AUTH_PREFIX = "Bearer" // {Bearer,JWT}
public var AUTH_TOKEN = ""
public let JSON_DECODER = JSONDecoder()

public var LIST_START_PAGE = 1

public var SIGN_UP_CONTROLLER: UIViewController.Type = UIViewController.self
public var SIGN_IN_CONTROLLER: UIViewController.Type = UIViewController.self

// SO https://stackoverflow.com/questions/38213286/overriding-methods-in-swift-extensions/#47447089
public protocol Config {
    static func config()

    static func onViewWillAppear(_ controller: UIViewController)

    static func onViewWillDisappear(_ controller: UIViewController)
}

extension Config {
    public static func config() {
        JSON_DECODER.dateDecodingStrategy = .iso8601
        print("empty")
//        showAlert(nil, message: "程序员请设置配置")
    }

    public static func onViewWillAppear(_ controller: UIViewController) {}

    public static func onViewWillDisappear(_ controller: UIViewController) {}
}

public struct Global: Config {}

/// 主题
public var APP_THEME = Theme()

public var WEB_HOST_TEXTS: [String: String]?

// 时间格式
public var DAY_FORMAT = "yyyy-MM-dd"
public var SECOND_FORMAT = "yyyy-MM-dd HH:mm:ss"

// 配置
public var isDebug = Defaults[.debug]

extension DefaultsKeys {
    public static let test_env = DefaultsKey<Bool>("test_env", defaultValue: false)
    static let debug = DefaultsKey<Bool>("debug", defaultValue: false)
}
