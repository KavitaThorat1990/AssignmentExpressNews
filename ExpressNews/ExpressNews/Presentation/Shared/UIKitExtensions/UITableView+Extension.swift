//
//  UITableView+Extension.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 30/12/23.
//

import UIKit

public typealias nibName = String

public protocol NibRegister {
    static var nibName: String { get }
    static var bundle: Bundle? { get }
}

public extension NibRegister {
    static var nibName: String {
        return String(describing: self)
    }

    static var bundle: Bundle? {
        return Bundle.main
    }
}

public extension UITableView {

    func registerCell(name: nibName, bundle: Bundle?) {
        let nib: UINib
        nib = UINib(nibName: name, bundle: bundle)
        self.register(nib, forCellReuseIdentifier: name)
    }

    func registerHeaderFooterView(name: nibName, bundle: Bundle?) {
        let nib = UINib(nibName: name, bundle: bundle)
        self.register(nib, forHeaderFooterViewReuseIdentifier: name)
    }

    /// to register table view header or footerView
    /// - Parameter cell: type of NibRegister & UITableViewHeaderFooterView
    func registerHeaderFooterView<T: NibRegister & UITableViewHeaderFooterView>(cell: T.Type) {
        self.registerHeaderFooterView(name: cell.nibName, bundle: cell.bundle)
    }
    
    func registerCell<T: NibRegister & UITableViewCell>(cell: T.Type) {
        self.registerCell(name: cell.nibName, bundle: cell.bundle)
    }
    
    func dequeueCell<T: UITableViewCell & NibRegister>(cell: T.Type, for path: IndexPath) -> T {
        guard let unwrappedCell = self.dequeueReusableCell(withIdentifier: cell.nibName, for: path) as? T else {
            //This is equivalent to force casting for cells. This will only be hit by developer error
            fatalError("failed to get cell and cast to correct type")
        }
        return unwrappedCell
    }
    
    func dequeueHeaderFooter<T: NibRegister & UITableViewHeaderFooterView>(_ headerFooter: T.Type) -> T {
        guard let unwrappedHeaderFooter = self.dequeueReusableHeaderFooterView(withIdentifier: headerFooter.nibName) as? T else {
            fatalError("failed to get header/footer and cast to correct type")
        }
        return unwrappedHeaderFooter
    }
}
