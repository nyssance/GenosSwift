//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

import Alamofire

public struct Call<D: Decodable> {
    public var method = HTTPMethod.get
    // 苹果处理30x跳转会丢掉Authorization头, 需要用getEndpint处理或手动加'/' https://github.com/Alamofire/Alamofire/issues/798
    public var endpoint = ""
    public var parameters: Parameters?

    public init(_ endpoint: String, _ parameters: Parameters? = nil) {
        self.init(.get, endpoint, parameters)
    }

    public init(_ method: HTTPMethod, _ endpoint: String, _ parameters: Parameters? = nil) {
        self.method = method
        self.endpoint = endpoint
        self.parameters = parameters
    }
}
