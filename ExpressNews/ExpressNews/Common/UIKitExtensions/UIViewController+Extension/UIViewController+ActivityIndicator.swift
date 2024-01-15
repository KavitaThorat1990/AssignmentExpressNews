//
//  UIViewController+ActivityIndicator.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 15/01/24.
//

import UIKit

extension UIViewController {

    private static var activityIndicatorViewTag: Int {
        return 987654 
    }

    func showActivityIndicator() {
        guard view.viewWithTag(UIViewController.activityIndicatorViewTag) == nil else {
            return
        }

        let indicatorView = UIView()
        indicatorView.tag = UIViewController.activityIndicatorViewTag
        indicatorView.backgroundColor = .secondarySystemBackground
        indicatorView.layer.cornerRadius = 10.0
        indicatorView.translatesAutoresizingMaskIntoConstraints = false

        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()

        indicatorView.addSubview(activityIndicator)

        view.addSubview(indicatorView)

        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            indicatorView.widthAnchor.constraint(equalToConstant: 80.0),
            indicatorView.heightAnchor.constraint(equalToConstant: 80.0),

            activityIndicator.centerXAnchor.constraint(equalTo: indicatorView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: indicatorView.centerYAnchor)
        ])
    }

    func hideActivityIndicator() {
        if let indicatorView = view.viewWithTag(UIViewController.activityIndicatorViewTag) {
            indicatorView.removeFromSuperview()
        }
    }
}

