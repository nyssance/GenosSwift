//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

public struct ShareUtils {
    public static var THIRD_PARTY_APPS = [
        "mqq": "qq",
        "weixin": "wechat",
        "fb": "facebook"
    ]

    public static func share(controller: UIViewController, items: [Any], view: UIView?) {
        let dest = UIActivityViewController(activityItems: items, applicationActivities: nil)
        dest.excludedActivityTypes = [
            .postToFacebook,
            .message, .mail,
            .print, .copyToPasteboard, .assignToContact,
            .saveToCameraRoll, // 系统自动只能存五张效果不好所以去除
            .addToReadingList,
            .postToFlickr, .postToVimeo, .postToTencentWeibo,
            .airDrop
        ]
        do { // SO https://stackoverflow.com/questions/25644054/uiactivityviewcontroller-crashing-on-ios8-ipads 适配iPad
            if let view = view {
                dest.popoverPresentationController?.sourceView = view
                dest.popoverPresentationController?.sourceRect = CGRect(x: view.frame.width / 2, y: 0, width: 0, height: 0)
            } else {
                dest.popoverPresentationController?.sourceView = controller.view
                dest.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: controller.view.frame.width, height: controller.view.frame.height / 2)
            }
        }
        controller.present(dest, animated: true, completion: nil)
    }
}
