//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

public class HttpLoader<D: Decodable>: BaseLoader<D> {
    public override func load(_ call: Call<D>, block: Bool = true) {
        if block {
            // TODO: 待增加
        }
        HttpUtils.request(call, success: { code, data in
            self.delegate?.onDataLoadSuccess(code, data: data)
        }, failure: { code, message in
            self.delegate?.onDataLoadFailure(code, message: message)
        }, complete: {
            self.delegate?.onDataLoadComplete()
        })
    }
}
