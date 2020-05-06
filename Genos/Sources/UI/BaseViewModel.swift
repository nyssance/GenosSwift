//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

import SwiftDate

public protocol ViewModel {}

open class IRepository<D: Decodable> {
    public func getData(_ call: Call<D>) {}
}

public class HttpRepository<D: Decodable>: IRepository<D> {
    public weak var delegate: LoaderController<D>?

    override public func getData(_ call: Call<D>) {
        HttpUtil.request(call, success: { code, data in
            self.delegate?.onDataLoadSuccess(code, data: data)
        }, failure: { code, message in
            self.delegate?.onDataLoadFailure(code, message: message)
        }, complete: {
            self.delegate?.onDataLoadComplete()
        })
    }
}

open class BaseViewModel<D: Decodable>: ViewModel {
    public var data: D?
    public var repo: IRepository<D> = IRepository<D>()

    public weak var delegate: LoaderController<D>?

    public init() {}

    public func loadData(_ call: Call<D>) {
//        repo.getData(call, success1: { data in
//            self.delegate?.onDisplay(data)
//        })
    }

    public func update(_ call: Call<D>) {}

    open func getDisplay(_ name: String, value: Any) -> String? {
        if value is Date {
            return (value as? Date)?.toFormat("yyyy-MM-dd HH:mm:ss")
        }
        return "\(value)"
    }
}
