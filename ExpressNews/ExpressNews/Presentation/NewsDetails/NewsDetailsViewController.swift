//
//  NewsDetailsViewController.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 03/01/24.
//

import UIKit

class NewsDetailsViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    var viewModel: NewsDetailsViewModel = NewsDetailsViewModel()
    var payload: [String: Any] = [:] {
        didSet {
            viewModel.configure(payload: payload)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    private func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.registerCell(cell: NewsDetailsCell.self)
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
        let cell = tableView.dequeueCell(cell: NewsDetailsCell.self, for: indexPath)
        if let newsArticle = viewModel.newsArticle {
            cell.configure(with: newsArticle)
            cell.openNewsURLClosure = {[weak self] in
                self?.openNewsURL()
            }
        }
        return cell
    }
}
