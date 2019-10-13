//
//  Copyright © 2018 NY <nyssance@icloud.com>. All rights reserved.
//

open class List<T: Decodable, V: UICollectionViewCell>: CollectionListController<[T], T, V> {
    open override func transformListFromData(data: [T]) -> [T] {
        data
    }
}
