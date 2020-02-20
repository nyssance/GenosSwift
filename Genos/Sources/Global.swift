//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

import DeviceKit
import SwiftyUserDefaults

public var APP_SCHEME = "genos"

public var AUTH_TOKEN = ""
public let JSON_DECODER = JSONDecoder()

public var LIST_START_PAGE = 1

public typealias Routes = [String: UIViewController.Type]

public var routes: Routes = [:]

// SO https://stackoverflow.com/questions/38213286/overriding-methods-in-swift-extensions/#47447089
public protocol Config {
    static func config()

    static func onViewWillAppear(_ controller: UIViewController)

    static func onViewWillDisappear(_ controller: UIViewController)
}

public extension Config {
    static func config() {
        JSON_DECODER.dateDecodingStrategy = .iso8601
        print("empty")
//        showAlert(nil, message: "程序员请设置配置")
    }

    static func onViewWillAppear(_ controller: UIViewController) {}

    static func onViewWillDisappear(_ controller: UIViewController) {}
}

public struct Global: Config {}

/// 主题
public var APP_THEME = Theme(color: .colorWithHex(0x007AFF))

public var WEB_HOST_TEXTS: [String: String]?

// 时间格式
public var DAY_FORMAT = "yyyy-MM-dd"
public var SECOND_FORMAT = "yyyy-MM-dd HH:mm:ss"

// 配置
public var isDebug = Defaults[\.debug]

public extension DefaultsKeys {
    var test_env: DefaultsKey<Bool> { .init("test_env", defaultValue: false) }
    var debug: DefaultsKey<Bool> { .init("debug", defaultValue: false) }
}

// 命名参考 TARGET_OS_IPHONE, TARGET_IPHONE_SIMULATOR
public let IS_IPHONE_PLUS = Device.current.isOneOf([.iPhone6Plus, .iPhone6sPlus, .iPhone7Plus, .iPhone8Plus, .simulator(.iPhone6Plus), .simulator(.iPhone6sPlus), .simulator(.iPhone7Plus), .simulator(.iPhone8Plus)])
public let IS_IPHONE_X = Device.current.isOneOf([.iPhoneX, .simulator(.iPhoneX), .iPhoneXR, .simulator(.iPhoneXR), .iPhoneXS, .simulator(.iPhoneXS)])
public let IS_IPHONE_XS_MAX = Device.current.isOneOf([.iPhoneXSMax, .simulator(.iPhoneXSMax)])

public let SCREEN_WIDTH = UIScreen.main.bounds.width
public let SCREEN_HEIGHT = UIScreen.main.bounds.height
public let SCREEN_MAX_LENGTH = max(SCREEN_WIDTH, SCREEN_HEIGHT)
public let SCREEN_MIN_LENGTH = min(SCREEN_WIDTH, SCREEN_HEIGHT)

public let STATUS_BAR_HEIGHT: CGFloat = IS_IPHONE_X || IS_IPHONE_XS_MAX ? 44 : 20
public let NAVIGATION_BAR_HEIGHT: CGFloat = 44
public let TOP_BAR_HEIGHT = STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT

public extension CGSize {
    static let appBarIcon = CGSize(width: 22, height: 22)
    static let tabBarIcon = CGSize(width: 25, height: 25)
    static let settingsIcon = CGSize(width: 29, height: 29)
}
