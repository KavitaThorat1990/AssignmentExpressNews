//
//  NewsDetailsViewController.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 03/01/24.
//

import UIKit
import SwiftUI

class NewsDetailsViewController: UIViewController {
    
    var viewModel: NewsDetailsViewModel = NewsDetailsViewModel()
    var payload: [String: Any] = [:] {
        didSet {
            viewModel.configure(payload: payload)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwiftUIView()
    }
    
    private func setupSwiftUIView() {
        guard let news = viewModel.newsArticle else {
            return
        }
        // 1
        let vc = UIHostingController(rootView: NewsDetailView(viewModel: NewsDetailsViewModel(newsArticle: news, openNewsURLClosure: { [weak self] in
            self?.openNewsURL()
        })))

        let newsDetailsView = vc.view!
        newsDetailsView.translatesAutoresizingMaskIntoConstraints = false
        
        // 2
        // Add the view controller to the destination view controller.
        addChild(vc)
        view.addSubview(newsDetailsView)
        
        // 3
        // Create and activate the constraints for the swiftui's view.
        NSLayoutConstraint.activate([
            newsDetailsView.topAnchor.constraint(equalTo: view.topAnchor),
            newsDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newsDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newsDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // 4
        // Notify the child view controller that the move is complete.
        vc.didMove(toParent: self)
    }


    @objc private func openNewsURL() {
        // open link within app or navigate to safari
        if let urlStr = viewModel.newsArticle?.url, let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
