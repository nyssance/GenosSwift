//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

import Alamofire

public typealias Parameters = Alamofire.Parameters
public typealias failureBlock = ((_ status: Int, _ message: String) -> Void)?

public struct HttpUtil {
    /// 上传到 bucket.
    public static func upload(data: Data, endpoint: String, parameters: Parameters, success: ((_ urlString: String) -> Void)? = nil, failure: failureBlock = nil) {
//        parameters["key"]?.let { it in
//            AF.upload(multipartFormData: { multipartFormData in
//                parameters.forEach { key, value in
//                    value.data(using: .utf8)?.let {
//                        multipartFormData.append($0, withName: key)
//                    }
//                }
//                parameters["Content-Type"]?.let {
//                    multipartFormData.append(data, withName: "file", fileName: it, mimeType: $0)
//                }
//            }, to: endpoint).responseJSON { response in
//                switch response.result {
//                case .success:
//                    success?(endpoint + it)
//                case let .failure(error):
//                    let status = response.response?.statusCode ?? 999
//                    failure?(status, error.localizedDescription)
//                    debugPrint(response)
//                }
//            }
//        }
    }

    public static func request<D: Decodable>(_ call: Call<D>, success: @escaping ((_ status: Int, _ data: D) -> Void), failure: failureBlock = nil, complete: (() -> Void)? = nil) {
        var endpoint = call.endpoint
        if !endpoint.contains("://") {
            endpoint = "\(BASE_URL)/\(endpoint)"
        }
        request(call.method, endpoint: endpoint, parameters: call.parameters ?? [:], success: { code, response in
            if let data = response.data {
                do {
                    let entity = try JSON_DECODER.decode(D.self, from: data)
                    success(code, entity)
                } catch {
                    showDebugAlert("Decoder 模型 \(D.self) 失败. \(error)")
                }
            } else {
                showDebugAlert("\(code) 成功, 但 data 为空")
            }
        }, failure: failure, complete: complete)
    }

    /// 传入参数执行.
    public static func request(_ method: HTTPMethod = .get, endpoint: String, parameters: Parameters = [:], success: ((_ status: Int, _ response: AFDataResponse<Any>) -> Void)?, failure: failureBlock = nil, complete: (() -> Void)? = nil) {
        guard let url = URL(string: endpoint) else {
            log.error("\(endpoint) 无法转化为URL")
            return
        }
//        var request = URLRequest(url: url)
//        request.httpMethod = method.rawValue
//        if AUTH_TOKEN.isNotBlank {
//            request.setValue("\(AUTH_PREFIX) \(AUTH_TOKEN)", forHTTPHeaderField: AUTH_HEADER)
//        }
//        if !parameters.isEmpty {
//            do {
//                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions()) // 这种方式GET应该无法传入参数
//            } catch {
//                log.error("HTTP 请求 增加参数 失败: \(error)")
//            }
//        }
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // POST请求必须要加这句
//        request.setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
//        request.setValue(APP_SCHEME, forHTTPHeaderField: "App-Scheme")
//        //        request.setValue("zh-CN", forHTTPHeaderField: "Accept-Language")
        // 请求
        var headers: HTTPHeaders = [
            .accept("application/json"),
            // .acceptLanguage("zh-CN"),
            HTTPHeader(name: "App-Scheme", value: APP_SCHEME),
            .contentType("application/json") // POST请求必须要加这句
        ]
        if AUTH_TOKEN.isNotBlank {
            headers.add(.authorization(bearerToken: AUTH_TOKEN))
        }
        AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                //            log.warning(request.allHTTPHeaderFields)
                //            log.error(response.response?.allHeaderFields)
                let status: Int
                switch response.result {
                case .success:
                    status = response.response?.statusCode ?? 666
                    log.debug("✅ \(status) \(method.rawValue) 🔗 \(endpoint)")
                    success?(status, response)
                case let .failure(error):
                    status = response.response?.statusCode ?? 999
                    log.debug("❌ \(status) \(method.rawValue) 🔗 \(endpoint)")
                    if let data = response.data {
                        let debug = isDebug ? "\(endpoint)\n\n" : ""
                        let utf8Text = String(data: data, encoding: .utf8) // 解决DRF-JWT返回unicode的问题
                        // response.result 在 AF 5.0 中不存在
                        let message = "\(debug)\(utf8Text ?? error.localizedDescription)"
                        if failure != nil { // 显示上层来的error函数
                            failure?(status, message)
                        } else {
                            showDebugAlert(title: "🐳 \(status)", message)
                        }
                    } else {
                        showDebugAlert("未知错误, 且response.data为空")
                    }
                }
                complete?()
            }
            .responseString { response in
                print("Response String: \(response.value.orEmpty())")
            }
    }
}
