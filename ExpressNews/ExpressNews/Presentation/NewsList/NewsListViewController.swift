//
//  NewsListViewController.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 02/01/24.
//

import UIKit

class NewsListViewController: UIViewController {

   @IBOutlet private weak var sortButton: UIButton!
   @IBOutlet private weak var filterButton: UIButton!
   @IBOutlet private weak var tableView: UITableView!
  
   private var sortActionSheet: UIAlertController?
   private var activityIndicator: UIActivityIndicatorView!

    private let filterViewController = FilterViewController.instantiate()

   var viewModel: NewsListViewModel!
   var payload: [String: Any] = [:]
    
   override func viewDidLoad() {
       super.viewDidLoad()
       setupViewModel()
       configureUI()
       fetchNews()
   }

   func configureUI() {
       navigationItem.title  = Constants.ScreenTitles.newsList
       tableView.registerCell(cell: NewsCell.self)
       // Set up activity indicator
       activityIndicator = UIActivityIndicatorView(style: .medium)
       activityIndicator.hidesWhenStopped = true
       tableView.tableFooterView = activityIndicator
   }

   private func setupViewModel() {
       viewModel = NewsListViewModel()
       viewModel.configure(payload: payload)
   }

   func fetchNews(queryParam: [String: Any] = [:]) {
       activityIndicator.startAnimating() // Start the activity indicator
       viewModel.fetchNews()
           .ensure { [weak self] in
               self?.activityIndicator.stopAnimating() // Stop the activity indicator, whether the request succeeds or fails
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
        let cell = tableView.dequeueCell(cell: NewsCell.self, for: indexPath)
        let newsArticle = viewModel.newsArticles[indexPath.row]
        cell.configure(with: newsArticle)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  Constants.CellHeights.newsCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = NewsDetailsViewController.instantiate()
        let newsArticle = viewModel.newsArticles[indexPath.row]
        detailsVC.payload = [Constants.PayloadKeys.newsArticle: newsArticle]
        navigationController?.pushViewController(detailsVC, animated: true)
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
    
   @IBAction private func sortButtonTapped() {
       if sortActionSheet == nil {
           createSortActionSheet()
       }

       present(sortActionSheet!, animated: true, completion: nil)
   }

    @IBAction func filterButtonTapped() {
        // Set the callback closure to receive selected options
        filterViewController.filterOptionsUpdated = { [weak self] selectedOptions in
            self?.viewModel.selectedFilterOptions = selectedOptions
            self?.viewModel.selectedCategory = ""
            self?.viewModel.resetPagination()
            self?.fetchNews()
        }

        present(filterViewController, animated: true, completion: nil)
    }
    
    private func createSortActionSheet() {
        sortActionSheet = UIAlertController(title: Constants.ScreenTitles.sortBy, message: nil, preferredStyle: .actionSheet)

        let sortingOptions: [SortOption] = [.relevancy, .popularity, .publishedAt]

        for option in sortingOptions {
            let action = UIAlertAction(title: option.title(), style: .default) { [weak self] _ in
                self?.viewModel.handleSortSelection(option: option)
                // Reset page info and fetch news
                self?.viewModel.resetPagination()
                self?.fetchNews()
            }
            sortActionSheet?.addAction(action)
        }

        let cancelAction = UIAlertAction(title: Constants.ButtonTitles.cancel, style: .cancel, handler: nil)
        sortActionSheet?.addAction(cancelAction)
    }
}
