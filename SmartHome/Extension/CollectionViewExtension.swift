//
//  CollectionViewExtension.swift
//  SmartHome
//
//  Created by Joao Batista on 13/10/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit

extension UICollectionView {

    func register<T: UICollectionViewCell>(_: T.Type, reuseIdentifier: String? = nil) {
        self.register(T.self, forCellWithReuseIdentifier: reuseIdentifier ?? String(describing: T.self))
    }

    func registerWithNib<T: UICollectionViewCell>(_: T.Type, reuseIdentifier: String? = nil) {
        self.register(UINib(nibName: String(describing: T.self), bundle: nil), forCellWithReuseIdentifier: reuseIdentifier ?? String(describing: T.self))
    }

    func dequeue<T: UICollectionViewCell>(_: T.Type, reuseIdentifier: String? = nil, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier ?? String(describing: T.self), for: indexPath) as? T
            else {
                fatalError("Could not deque cell with type \(T.self)")
        }
        return cell
    }

}

extension UICollectionView {

    static func standard(direction: UICollectionView.ScrollDirection = .horizontal, enabledScroll: Bool = true, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0) -> UICollectionView {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = direction
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.minimumLineSpacing = minimumLineSpacing
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = enabledScroll
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }
}
