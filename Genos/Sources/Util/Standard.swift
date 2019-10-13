//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

protocol Standard {}

extension Standard {
    func with(_ receiver: Any?, block: (_ this: Self) -> Void) {
        block(self)
    }

    func apply(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }

    func also(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }

    func `let`(_ block: (Self) -> Void) {
        block(self)
    }

//    func with(receiver: T, block: T.() -> R): R {
//        contract {
//            callsInPlace(block, InvocationKind.EXACTLY_ONCE)
//        }
//        return receiver.block()
//    }
}

extension NSObject: Standard {}

extension URL: Standard {}

extension Mirror: Standard {}

extension CGFloat: Standard {}

extension Data: Standard {}

extension String: Standard {}
