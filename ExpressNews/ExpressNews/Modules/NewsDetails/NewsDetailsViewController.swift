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

        let vc = UIHostingController(rootView: NewsDetailView(viewModel: viewModel))

        guard let newsDetailsView = vc.view else {
            return
        }
        newsDetailsView.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(vc)
        view.addSubview(newsDetailsView)
        
        NSLayoutConstraint.activate([
            newsDetailsView.topAnchor.constraint(equalTo: view.topAnchor),
            newsDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newsDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newsDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        vc.didMove(toParent: self)
    }
}
