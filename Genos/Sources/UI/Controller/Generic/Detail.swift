//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

open class Detail<D: Decodable>: LoaderController<D> {
    open func onPerform(action: Action) {
        switch action {
        default:
            break
        }
    }
}

public struct Exception: Hashable, Codable {
    var message: String = "exception".locale
}

open class Blank<D: Decodable>: Detail<D> {}

public class Exception404: Detail<Exception> {}
