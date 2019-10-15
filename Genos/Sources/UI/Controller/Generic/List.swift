//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

open class List<T: Decodable, V: UICollectionViewCell>: CollectionViewListController<[T], T, V> {
    open override func transformListFromData(data: [T]) -> [T] {
        data
    }
}
