//
//  Copyright © 2019 NY <nyssance@icloud.com>. All rights reserved.
//

open class CollectionViewController<D: Decodable, T: Decodable, V: UICollectionViewCell>: AbsListViewController<D, T, UICollectionView, V>, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: - 👊 Genos

    override public func onCreateListView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout().apply {
            $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout).apply { it in
            it.dataSource = self
            it.prefetchDataSource = self
            it.delegate = self
            it.register(V.self, forCellWithReuseIdentifier: tileId)
        }
        return collectionView
    }

    // MARK: - 🔹 UICollectionViewDataSource

    public final func numberOfSections(in collectionView: UICollectionView) -> Int {
        adapter.getSectionCount()
    }

    public final func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        adapter.getSectionItemCount(section)
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: tileId, for: indexPath)
    }

    // MARK: 🔹 UICollectionViewDataSourcePrefetching

    open func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {}

    // MARK: 🔹 UICollectionViewDelegate

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let view = cell as? V {
            onDisplayItem(item: adapter.getItem(indexPath), view: view, viewType: onGetItemViewType(indexPath))
        } else {
            log.error("Cell 类型 或 初始化 出错, 导致为空.")
        }
    }

    public final func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.allowsMultipleSelection { // 多选
        } else { // 单选
            let item = adapter.getItem(indexPath)
            onPerform(action: .open, item: item)
            if needDeselect(item) {
                collectionView.deselectItem(at: indexPath, animated: true)
            }
        }
    }

    // MARK: 🔹 UIScrollViewDelegate

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onScrollViewDidScroll(scrollView)
    }
}
