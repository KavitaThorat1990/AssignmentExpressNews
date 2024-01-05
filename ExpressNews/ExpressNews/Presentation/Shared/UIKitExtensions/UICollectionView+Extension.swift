//
//  UICollectionView+Extension.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 05/01/24.
//

import UIKit

extension UICollectionView {

    public func registerCell(name: nibName, bundle: Bundle?) {
        let nib = UINib(nibName: name, bundle: bundle)
        self.register(nib, forCellWithReuseIdentifier: name)
    }

    public func registerCell<T: NibRegister & UICollectionViewCell>(cell: T.Type) {
        self.registerCell(name: cell.nibName, bundle: cell.bundle)
    }

    public func dequeueCell<T: UICollectionViewCell & NibRegister>(cell: T.Type, for path: IndexPath) -> T {

        guard let unwrappedCell = self.dequeueReusableCell(withReuseIdentifier: cell.nibName, for: path) as? T else {
            //This is equivalent to force casting for cells. This will only be hit by developer error
            fatalError("failed to get cell and cast to correct type")
        }
        return unwrappedCell
    }
}
