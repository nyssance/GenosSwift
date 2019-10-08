//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

import DeviceKit

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

public let CGSizeNavigationBarIcon = CGSize(width: 22, height: 22)
public let CGSizeToolbarIcon = CGSize(width: 22, height: 22)
public let CGSizeTabBarIcon = CGSize(width: 25, height: 25)
public let CGSizeSettingsIcon = CGSize(width: 29, height: 29)

public let FLEXIBLE_SPACE = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
