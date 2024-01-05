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
        configureUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.isActive = true
        searchBar.searchBar.becomeFirstResponder()
    }
    
   override func configureUI() {
       super.configureUI()
       navigationItem.title = Constants.ScreenTitles.search
        navigationItem.searchController = searchBar
        searchBar.searchBar.delegate = self
        searchBar.isActive = true
        searchBar.searchBar.becomeFirstResponder()
       
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
