//
//  UIViewController+NavigationBarButton.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 15/01/24.
//

import Foundation
import UIKit

extension UIViewController {
    func addRightBarButtonItemToNavigationBar(systemItem: UIBarButtonItem.SystemItem, actionSelector: Selector) {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: self, action: actionSelector)
        navigationItem.rightBarButtonItem = barButtonItem
    }
}
