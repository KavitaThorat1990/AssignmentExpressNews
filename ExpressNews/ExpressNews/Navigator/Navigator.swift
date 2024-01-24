//
//  Coordinator.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 15/01/24.
//

import UIKit

protocol Navigator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
    func navigateToNewsDetails(_ news: NewsArticle, presentationStyle: PresentationStyle)
    func navigateToNewsList(for category: String, presentationStyle: PresentationStyle)
    func openUrl(_ url: URL)
    func dismissViewController()
}

enum PresentationStyle {
    case push
    case present
}
