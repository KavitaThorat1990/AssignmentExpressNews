//
//  NewsDetailsViewController.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 03/01/24.
//

import UIKit
import SwiftUI

class NewsDetailsViewController: UIViewController {
    private var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    var viewModel: NewsDetailsViewModel = NewsDetailsViewModel()
    var payload: [String: Any] = [:] {
        didSet {
            viewModel.configure(payload: payload)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        // Set up the table view
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NewsDetailsCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
    }

    @objc private func openNewsURL() {
        // open link within app or navigate to safari
        if let urlStr = viewModel.newsArticle?.url, let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension NewsDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsDetailsCell") else {
            return UITableViewCell()
        }
        if let newsArticle = viewModel.newsArticle {
            
            let detailsCell = NewsDetailsCell(newsArticle: newsArticle) { [weak self] in
                self?.openNewsURL()
            }
            if #available(iOS 16.0, *) {
                cell.contentConfiguration = UIHostingConfiguration(content: {
                    detailsCell
                })
            } else {
                cell.contentConfiguration = HostingContentConfiguration {
                    detailsCell
                }
            }
        }
        return cell
    }
}
