//
//  UIViewController+Extension.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 04/01/24.
//

import UIKit
import ANActivityIndicator

extension UIViewController {
    func addRightBarButtonItemToNavigationBar(systemItem: UIBarButtonItem.SystemItem, actionSelector: Selector) {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: self, action: actionSelector)
        navigationItem.rightBarButtonItem = barButtonItem
    }
}

extension UIViewController {
    static var identifier: String {
        return String(describing: self)
    }

    static func instantiate(storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)) -> Self {
        return storyboard.instantiateViewController(withIdentifier: identifier) as! Self
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
