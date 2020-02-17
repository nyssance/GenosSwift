//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

import Alamofire

public enum Cloud: String, CaseIterable {
    case Aliyun = "aliyun"
    case AWS = "aws"
}

public struct CloudUtil {
    /// 上传到云存储.
    public static func upload(_ cloud: Cloud, filename: String, data: Data, controller: UIViewController, success: ((_ urlString: String) -> Void)? = nil, failure: failureBlock = nil) {
        getUploadParams(cloud, filename: filename) { endpoint, params in
            HttpUtil.upload(data: data, endpoint: endpoint, parameters: params, success: success, failure: failure)
        }
    }

    /// 获取云存储上传参数.
    private static func getUploadParams(_ cloud: Cloud, filename: String, success: @escaping (_ endpoint: String, _ params: Parameters) -> Void) {
        // 请求 API 上传需要的参数
        // let parameters = ["filename": filename]
        // filename: 文件保存全路径, 默认: upload/uuid4().hex.json
        // expiration 有效时间 默认: 50year
        HttpUtil.request(Api.uploadParams(cloud: cloud.rawValue, filename: filename), success: { _, data in
            success(data.endpoint, data.params)
        })
    }
}
