//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

open class BaseLoader<D: Decodable> {
    public weak var delegate: LoaderController<D>?
    public var call: Call<D>

    public required init(call: Call<D>) {
        self.call = call
    }

    open func load() {
        load(call)
    }

    open func load(_ call: Call<D>, block: Bool = true) {}
}
