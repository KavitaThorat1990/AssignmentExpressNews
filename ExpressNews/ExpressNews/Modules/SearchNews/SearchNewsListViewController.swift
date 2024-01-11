//
//  SearchNewsListViewController.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 03/01/24.
//

import UIKit

class SearchNewsListViewController: NewsListViewController {
        
    private var searchBar: UISearchController = {
        let sb = UISearchController()
        sb.searchBar.placeholder = Constants.ScreenTitles.search
        sb.searchBar.searchBarStyle = .minimal
        return sb
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.isActive = true
        searchBar.searchBar.becomeFirstResponder()
    }
    
   override func setupUI() {
       view.backgroundColor = .white
       navigationItem.title = Constants.ScreenTitles.search
       
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
       tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.CellIds.newsCell)

       navigationItem.searchController = searchBar
       searchBar.searchBar.delegate = self
       searchBar.isActive = true
       searchBar.searchBar.becomeFirstResponder()
       
       super.setupActivityIndicator()
    }
    
    override func fetchNews(queryParam: [String : Any] = [:]) {
        if queryParam.isEmpty {
            return
        }
        super.fetchNews(queryParam: queryParam)
    }
}

extension SearchNewsListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.count > 0 else {
            return
        }
        // Use the search term to filter news articles
        viewModel.resetPagination()
        self.fetchNews(queryParam: [APIConstants.RequestParameters.query: query])
    }
}
