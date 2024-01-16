//
//  NewsListViewController.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 02/01/24.
//

import UIKit
import SwiftUI

class NewsListViewController: UIViewController {

    private var sortButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.ButtonTitles.sort, for: .normal)
        button.setImage(UIImage(systemName: Constants.ImageNames.sort), for: .normal)
        return button
    }()
    
    private var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.ButtonTitles.filter, for: .normal)
        button.setImage(UIImage(systemName: Constants.ImageNames.filter), for: .normal)
        button.accessibilityIdentifier = Constants.AccessibilityIds.filterButton
        return button
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
  
   private var sortActionSheet: UIAlertController?
   private var activityIndicator: UIActivityIndicatorView?

    private let filterViewController = FilterViewController()

   var viewModel: NewsListViewModel?
   var payload: [String: Any] = [:]
    
   override func viewDidLoad() {
       super.viewDidLoad()
       setupViewModel()
       setupUI()
       fetchNews()
   }

    func setupActivityIndicator() {
        // Set up activity indicator
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator?.hidesWhenStopped = true
        tableView.tableFooterView = activityIndicator
    }
    
    func setupUI() {
       navigationItem.title  = Constants.ScreenTitles.newsList
       view.backgroundColor = .white

       view.addSubview(sortButton)
       sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
       sortButton.translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([
           sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
           sortButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
           sortButton.widthAnchor.constraint(equalToConstant: 80),
           sortButton.heightAnchor.constraint(equalToConstant: 40)
       ])

       view.addSubview(filterButton)
       filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
       filterButton.translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([
           filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
           filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
           filterButton.widthAnchor.constraint(equalToConstant: 80),
           filterButton.heightAnchor.constraint(equalToConstant: 40)
       ])

       view.addSubview(tableView)
       tableView.translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([
           tableView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 5),
           tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
       ])

       tableView.delegate = self
       tableView.dataSource = self
       
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.CellIds.newsCell)

       setupActivityIndicator()
   }

   private func setupViewModel() {
       viewModel = NewsListViewModel()
       viewModel?.configure(payload: payload)
   }

   func fetchNews(queryParam: [String: Any] = [:]) {
       activityIndicator?.startAnimating() // Start the activity indicator
       viewModel?.fetchNews()
           .ensure { [weak self] in
               self?.activityIndicator?.stopAnimating() // Stop the activity indicator, whether the request succeeds or fails
           }
           .done { [weak self] _ in
               self?.updateUI()
           }
           .catch { [weak self] error in
               self?.handleAPIError(error)
           }
    }
    
    func updateUI() {
        tableView.reloadData()
    }

}

extension NewsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.newsArticles.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIds.newsCell), let news = viewModel?.newsArticles[indexPath.row] else {
            return UITableViewCell()
        }
       
        let newsCell = NewsCell(cellViewModel: NewsCellViewModel(news: news))
        if #available(iOS 16.0, *) {
            cell.contentConfiguration = UIHostingConfiguration(content: {
                newsCell
            })
           } else {
               cell.contentConfiguration = HostingContentConfiguration {
                   newsCell
                       .padding()
               }
           }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  Constants.CellHeights.newsCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let newsArticle = viewModel?.newsArticles[indexPath.row] {
            NewsAppCoordinator.shared.navigateToNewsDetails(newsArticle, presentationStyle: .push)
        }
    }
}

extension NewsListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {
            fetchNews()
        }
    }
}

extension NewsListViewController {
    
   @objc private func sortButtonTapped() {
       if sortActionSheet == nil {
           createSortActionSheet()
       }
       if let actionSheet = sortActionSheet {
           NewsAppCoordinator.shared.navigateTo(presentationStyle: .present, toViewController: actionSheet)
       }
   }

    @objc func filterButtonTapped() {
        // Set the callback closure to receive selected options
        filterViewController.filterOptionsUpdated = { [weak self] selectedOptions in
            self?.viewModel?.selectedFilterOptions = selectedOptions
            self?.viewModel?.selectedCategory = ""
            self?.viewModel?.resetPagination()
            self?.fetchNews()
        }
        NewsAppCoordinator.shared.navigateTo(presentationStyle: .present, toViewController: filterViewController)
    }
    
    private func createSortActionSheet() {
        sortActionSheet = UIAlertController(title: Constants.ScreenTitles.sortBy, message: nil, preferredStyle: .actionSheet)

        let sortingOptions: [SortOption] = [.relevancy, .popularity, .publishedAt]

        for option in sortingOptions {
            let action = UIAlertAction(title: option.title(), style: .default) { [weak self] _ in
                self?.viewModel?.handleSortSelection(option: option)
                // Reset page info and fetch news
                self?.viewModel?.resetPagination()
                self?.fetchNews()
            }
            sortActionSheet?.addAction(action)
        }

        let cancelAction = UIAlertAction(title: Constants.ButtonTitles.cancel, style: .cancel, handler: nil)
        sortActionSheet?.addAction(cancelAction)
    }
}
