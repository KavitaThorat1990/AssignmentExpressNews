//
//  NewsAppCoordinator.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 15/01/24.
//

import UIKit

class NewsAppCoordinator: Coordinator {
    var navigationController: UINavigationController

    static let shared = NewsAppCoordinator()

    private init() {
        // Private initializer to ensure singleton
        self.navigationController = UINavigationController()
    }

    func start() {
        navigateToHome()
    }
    
    func navigateToHome() {
        let homeViewController = HomeViewController()
        navigateTo(presentationStyle: .push, toViewController: homeViewController)
    }

    func navigateTo(presentationStyle: PresentationStyle, toViewController: UIViewController) {
        switch presentationStyle {
        case .push:
            navigationController.pushViewController(toViewController, animated: true)
        case .present:
            navigationController.present(toViewController, animated: true, completion: nil)
        }
    }
    
    func navigateToNewsDetails(_ news: NewsArticle, presentationStyle: PresentationStyle) {
        let newsDetailsViewController = NewsDetailsViewController()
        newsDetailsViewController.payload = [Constants.PayloadKeys.newsArticle: news]
        navigateTo(presentationStyle: presentationStyle, toViewController: newsDetailsViewController)
    }
    
    func navigateToSearch(_ presentationStyle: PresentationStyle) {
        let searchNewsVC = SearchNewsListViewController()
        navigateTo(presentationStyle: presentationStyle, toViewController: searchNewsVC)
    }
    
    func navigateToNewsList(for category: String, presentationStyle: PresentationStyle) {
        let newsListVC = NewsListViewController()
        newsListVC.payload = [Constants.PayloadKeys.category: category]
        navigateTo(presentationStyle: presentationStyle, toViewController: newsListVC)
    }

    func dismissViewController() {
        if let presentedViewController = navigationController.presentedViewController {
            presentedViewController.dismiss(animated: true, completion: nil)
        } else {
            navigationController.popViewController(animated: true)
        }
    }
}
