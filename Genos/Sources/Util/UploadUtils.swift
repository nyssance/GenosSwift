//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

public struct UploadUtils {
    /// 上传到云存储.
    public static func uploadToCloud(cloud: String, filename: String, data: Data, controller: UIViewController, success: ((_ urlString: String) -> Void)? = nil, failure: failureBlock = nil) {
        getCloudUploadParams(cloud: cloud, filename: filename) { endpoint, params in
            HttpUtils.upload(data: data, endpoint: endpoint, parameters: params, success: success, failure: failure)
        }
    }

    /// 获取云存储上传参数.
    private static func getCloudUploadParams(cloud: String, filename: String, success: @escaping (_ endpoint: String, _ params: [String: String]) -> Void) {
        // 请求 API 上传需要的参数
        // let parameters = ["filename": filename]
        // filename: 文件保存全路径, 默认: upload/uuid4().hex.json
        // expiration 有效时间 默认: 50year
        HttpUtils.request(API.uploadParams(cloud: cloud, filename: filename), success: { _, data in
            success(data.endpoint, data.params)
        })
    }
}
