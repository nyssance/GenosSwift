//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

public struct API {
    /// 获取上传参数.
    /// - parameter cloud: 可选参数: aliyun(别名 oss), aws(别名 s3).
    /// - parameter filename: 文件名
    public static func uploadParams(cloud: String, filename: String) -> Call<UploadParams> {
        return Call(.post, "upload_params/\(cloud)/", ["filename": filename])
    }
}
