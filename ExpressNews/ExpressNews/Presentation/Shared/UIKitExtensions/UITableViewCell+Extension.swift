//
//  UITableViewCell+Extension.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 05/01/24.
//

import UIKit

extension UITableViewCell {
    public func showSeparator(_ defaultPadding: CGFloat = 15.0) {
        separatorInset = UIEdgeInsets(top: 0.0, left: defaultPadding, bottom: 0.0, right: defaultPadding)
    }
    
    public func hideSeparator() {
        separatorInset = UIEdgeInsets(top: 0.0, left: UIScreen.main.bounds.width, bottom: 0.0, right: 0.0)
    }
}
