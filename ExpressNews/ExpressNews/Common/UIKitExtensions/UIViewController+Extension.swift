//
//  UIViewController+Extension.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 04/01/24.
//

import UIKit

extension UIViewController {
    func addRightBarButtonItemToNavigationBar(systemItem: UIBarButtonItem.SystemItem, actionSelector: Selector) {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: self, action: actionSelector)
        navigationItem.rightBarButtonItem = barButtonItem
    }
}

extension UIViewController {
    func handleAPIError(_ error: Error) {
        if let apiError = error as? APIError {
            switch apiError {
            case .decodingFailed(let decodingError):
                showAlert(message: "Decoding failed with error: \(decodingError.localizedDescription)")
            case .invalidURL:
                showAlert(message: "Invalid URL")
            case .invalidResponse:
                showAlert(message: "Invalid response from the server")
            case .requestFailed(let requestError):
                showAlert(message: "Request failed with error: \(requestError.localizedDescription)")
            default:
                showAlert(message: "An unexpected error occurred")
            }
        } else {
            showAlert(message: "An unexpected error occurred")
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}


extension UIViewController {

    private static var activityIndicatorViewTag: Int {
        return 987654 // Unique tag for the activity indicator view
    }

    // Show activity indicator with a white background and corner radius
    func showActivityIndicator() {
        guard view.viewWithTag(UIViewController.activityIndicatorViewTag) == nil else {
            // Activity indicator is already displayed
            return
        }

        // Create the activity indicator view
        let indicatorView = UIView()
        indicatorView.tag = UIViewController.activityIndicatorViewTag
        indicatorView.backgroundColor = .secondarySystemBackground
        indicatorView.layer.cornerRadius = 10.0
        indicatorView.translatesAutoresizingMaskIntoConstraints = false

        // Create the activity indicator
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()

        // Add the activity indicator to the indicator view
        indicatorView.addSubview(activityIndicator)

        // Add the indicator view to the main view
        view.addSubview(indicatorView)

        // Center the indicator view
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            indicatorView.widthAnchor.constraint(equalToConstant: 80.0),
            indicatorView.heightAnchor.constraint(equalToConstant: 80.0),

            activityIndicator.centerXAnchor.constraint(equalTo: indicatorView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: indicatorView.centerYAnchor)
        ])
    }

    // Hide the activity indicator
    func hideActivityIndicator() {
        if let indicatorView = view.viewWithTag(UIViewController.activityIndicatorViewTag) {
            indicatorView.removeFromSuperview()
        }
    }
}
