//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

// SO https://stackoverflow.com/questions/47586520/is-there-an-kotlin-equivalent-with-function-in-swift/#47587455
public protocol Standard {}

public extension Standard {
    @inline(__always)
    func with<T>(_ this: T, block: (T) -> () -> T) -> T {
        block(this)()
    }

    @inline(__always)
    func apply(block: (Self) -> Void) -> Self {
        block(self)
        return self
    }

    @inline(__always)
    func also(block: (Self) -> Void) -> Self {
        block(self)
        return self
    }

    @inline(__always)
    func `let`<R>(block: (Self) -> R) -> R {
        block(self)
    }

//    func with(receiver: T, block: T.() -> R): R {
//        contract {
//            callsInPlace(block, InvocationKind.EXACTLY_ONCE)
//        }
//        receiver.block()
//    }
}

extension NSObject: Standard {}

extension URL: Standard {}

extension Mirror: Standard {}

extension CGFloat: Standard {}

extension Data: Standard {}

extension String: Standard {}
