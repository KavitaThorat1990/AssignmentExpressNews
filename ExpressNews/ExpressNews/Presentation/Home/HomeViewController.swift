//
//  HomeViewController.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 30/12/23.
//

import UIKit
import PromiseKit

class HomeViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!

    var viewModel: HomeViewModel!
    var featuredNewsCell: FeaturedNewsCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel()
        setupUI()
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        featuredNewsCell?.startAutoScroll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        featuredNewsCell?.stopAutoScroll()
    }
    private func setupUI() {
        addRightBarButtonItemToNavigationBar(systemItem: .search, actionSelector: #selector(searchButtonTapped))

        tableView.tableFooterView = UIView()

        // Configure cell registration for collection views and table views
        tableView.registerCell(cell: FeaturedNewsCell.self)
        tableView.registerCell(cell: NewsCell.self)
        tableView.registerHeaderFooterView(cell: NewsCategoryHeader.self)
        featuredNewsCell = tableView.dequeueCell(cell: FeaturedNewsCell.self, for: IndexPath(row: 0, section: 0))
        featuredNewsCell?.openNewsDetails = {[weak self] news in
            self?.navigateToNewsDetails(news)
        }
    }

    private func loadData() {
        // Fetch data using promises
        showIndicator()
        let fetchFeatured = viewModel.fetchFeaturedNews(parameters: [APIConstants.RequestParameters.country: Constants.defaultCountry, APIConstants.RequestParameters.pageSize: Constants.pageSizeForFeatured])
        let fetchTrending = viewModel.fetchTrendingNewsForCategories(parameters: [APIConstants.RequestParameters.country: Constants.defaultCountry, APIConstants.RequestParameters.pageSize: Constants.pageSizeForHome])
        
        when(fulfilled: fetchFeatured, fetchTrending)
            .ensure { [weak self] in
                self?.hideIndicator()
            }
            .done { [weak self] (_, _) in
                self?.updateUI()
            }
            .catch {[weak self]  error in
                // Handle the error
                self?.handleAPIError(error)
            }
    }
    
    func updateUI() {
        tableView.reloadData()
    }
    
    private func seeAllButtonTapped(for category: String) {
        let newsListVC = NewsListViewController.instantiate()
        newsListVC.payload = [Constants.PayloadKeys.category: category]

        navigationController?.pushViewController(newsListVC, animated: true)
    }
    
    @objc func searchButtonTapped() {
        let searchNewsVC = SearchNewsListViewController.instantiate()
        navigationController?.pushViewController(searchNewsVC, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.categories.count + 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return viewModel.numberOfRowsForSection(section: section)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            featuredNewsCell?.configure(with: viewModel.featuredNews)
            return featuredNewsCell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueCell(cell: NewsCell.self, for: indexPath)
            let news = viewModel.getNewsForSection(section: indexPath.section)[indexPath.row]
            cell.configure(with: news)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return Constants.CellHeights.featuredCell
        } else {
            return  Constants.CellHeights.newsCell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       if section != 0 {
           let headerView = tableView.dequeueHeaderFooter(NewsCategoryHeader.self)
           headerView.titleLabel.text = viewModel.categories[section - 1]
           headerView.seeAllButton.addTarget(self, action: #selector(seeAllButtonTapped(sender:)), for: .touchUpInside)
           return headerView
       }
       return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section != 0 ?  Constants.CellHeights.categoryHeader : 0.0
    }

    fileprivate func navigateToNewsDetails(_ news: NewsArticle) {
        let detailsVC = NewsDetailsViewController.instantiate()
        detailsVC.payload = [Constants.PayloadKeys.newsArticle: news]
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            let news = viewModel.getNewsForSection(section: indexPath.section)[indexPath.row]
            navigateToNewsDetails(news)
        }
    }
    
    @objc func seeAllButtonTapped(sender: UIButton) {
       guard let header = sender.superview as? NewsCategoryHeader else {
           return
       }
       let category = header.titleLabel.text ?? ""
       seeAllButtonTapped(for: category)
    }
}
