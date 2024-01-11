//
//  HomeViewController.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 30/12/23.
//

import UIKit
import PromiseKit
import SwiftUI

class HomeViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGroupedBackground
        return tableView
    }()

    var viewModel: HomeViewModel!
    private var featuredNewsCell: FeaturedNewsCell?

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
        navigationItem.title = Constants.ScreenTitles.home
        //add search button
        addRightBarButtonItemToNavigationBar(systemItem: .search, actionSelector: #selector(searchButtonTapped))
        
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

        // Configure cell registration for collection views and table views
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.CellIds.newsCell)
        tableView.register(FeaturedNewsCell.self, forCellReuseIdentifier: Constants.CellIds.featuredNewsCell)

        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: Constants.CellIds.newsCategoryHeader)
        featuredNewsCell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIds.featuredNewsCell) as? FeaturedNewsCell
        featuredNewsCell?.payload = [Constants.PayloadKeys.newsList: viewModel.featuredNews]
        featuredNewsCell?.openNewsDetails = {[weak self] news in
            self?.navigateToNewsDetails(news)
        }
    }

    private func loadData() {
        // Fetch data using promises
        showActivityIndicator()
        let fetchFeatured = viewModel.fetchFeaturedNews(parameters: [APIConstants.RequestParameters.country: Constants.defaultCountry, APIConstants.RequestParameters.pageSize: Constants.pageSizeForFeatured])
        let fetchTrending = viewModel.fetchTrendingNewsForCategories(parameters: [APIConstants.RequestParameters.country: Constants.defaultCountry, APIConstants.RequestParameters.pageSize: Constants.pageSizeForHome])
        
        when(fulfilled: fetchFeatured, fetchTrending)
            .ensure { [weak self] in
                self?.hideActivityIndicator()
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
        let newsListVC = NewsListViewController()
        newsListVC.payload = [Constants.PayloadKeys.category: category]

        navigationController?.pushViewController(newsListVC, animated: true)
    }
    
    @objc func searchButtonTapped() {
        let searchNewsVC = SearchNewsListViewController()
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIds.newsCell) else {
                return UITableViewCell()
            }
            let news = viewModel.getNewsForSection(section: indexPath.section)[indexPath.row]
            if #available(iOS 16.0, *) {
                cell.contentConfiguration = UIHostingConfiguration(content: {
                    NewsCell(news: news)
                })
               } else {
                   cell.contentConfiguration = HostingContentConfiguration {
                       NewsCell(news: news)
                           .padding()
                           .frame(height: 100)
                   }
               }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return Constants.CellHeights.featuredCell
        } else {
            return Constants.CellHeights.newsCell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       if section != 0 {
           guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.CellIds.newsCategoryHeader) else {
               return nil
           }
           let category = viewModel.categories[section - 1]
           let newsHeader = NewsCategoryHeader(title: category) { [weak self] in
               self?.seeAllButtonTapped(for: category)
           }
           
           if #available(iOS 16.0, *) {
               headerView.contentConfiguration = UIHostingConfiguration(content: {
                   newsHeader
               })
           } else {
               headerView.contentConfiguration = HostingContentConfiguration {
                   newsHeader
               }
           }
           return headerView
       }
       return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section != 0 ?  Constants.CellHeights.categoryHeader : 0.0
    }

    fileprivate func navigateToNewsDetails(_ news: NewsArticle) {
        let detailsVC = NewsDetailsViewController()
        detailsVC.payload = [Constants.PayloadKeys.newsArticle: news]
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            let news = viewModel.getNewsForSection(section: indexPath.section)[indexPath.row]
            navigateToNewsDetails(news)
        }
    }
}
