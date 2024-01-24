//
//  NewsListViewModel.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 02/01/24.
//

import Foundation
import PromiseKit

//enum for sorting options
enum SortOption: String {
    case relevancy
    case popularity
    case publishedAt
    
    func title() -> String {
        switch self {
        case .relevancy,. popularity:
            return self.rawValue.capitalized
        case .publishedAt:
            return "Published At"
        }
    }
}

final class NewsListViewModel {
    private var newsArticles: [NewsArticle] = []
    private let sortingOptions: [SortOption] = [.relevancy, .popularity, .publishedAt]
    private var selectedCategory: String = ""
    private var selectedSortOption: SortOption = .publishedAt
    private var selectedFilterOptions: [String: [String]] = [:]
    private var currentPage: Int = 1
    private let pageSize: Int = Constants.pageSizeForNewsList
    private let newsUseCase: NewsUseCaseProtocol

    init(newsUseCase: NewsUseCaseProtocol = NewsUseCase()) {
        self.newsUseCase = newsUseCase
    }
    
    func configure(payload: [String: Any]) {
        if let category = payload[Constants.PayloadKeys.category] as? String{
            selectedCategory = category
        }
    }
    
    func getAPIParameters() -> [String: Any] {
       var parameters: [String: String] = [:]

       for (key, values) in selectedFilterOptions {
           // Convert the array of values into a comma-separated string
           if values.count > 0 {
               let joinedValues = values.joined(separator: ",")
               parameters[key.lowercased()] = joinedValues.lowercased()
           }
       }

       return parameters
   }
    
    func fetchNews(queryParam: [String: Any] = [:]) -> Promise<Void> {
        var parameters: [String: Any] = [APIConstants.RequestParameters.category : selectedCategory, APIConstants.RequestParameters.country: Constants.defaultCountry, APIConstants.RequestParameters.pageSize: pageSize, APIConstants.RequestParameters.page: currentPage, APIConstants.RequestParameters.sortBy: selectedSortOption.rawValue]
        parameters.merge(getAPIParameters()) { (_, new) in new }
        
        if let sources = parameters[APIConstants.RequestParameters.sources] as? String, sources.count > 0 {
            parameters.removeValue(forKey: APIConstants.RequestParameters.country)
            parameters.removeValue(forKey: APIConstants.RequestParameters.category)
        }
        return firstly {
            newsUseCase.fetchNews(parameters: parameters)
        }.map {[weak self] articles in
            self?.newsArticles.append(contentsOf: articles)
            self?.currentPage += 1  // Increment the page for the next request
            return
        }
    }
    
    func resetPagination() {
        currentPage = 1
        newsArticles.removeAll()
    }
    
    func handleSortSelection(option: SortOption) {
        self.selectedSortOption = option
    }
    
    func getSelectedSortOption() -> SortOption {
        return selectedSortOption
    }
    
    func getNews(for index: Int) -> NewsArticle? {
        guard index < newsArticles.count else {
            return nil
        }
        return newsArticles[index]
    }
    
    func getSelectedCategory() -> String {
        return selectedCategory
    }
    
    func getCurrentPage() -> Int {
        return currentPage
    }
    
    func setSelectedCategory(_ category: String) {
        selectedCategory = category
    }
    
    func setSelectedFilterOptions(selectedOptions: [String: [String]]) {
        selectedFilterOptions = selectedOptions
        selectedCategory = ""
        resetPagination()
    }
    
    func didSelectRowAt(index: Int) {
        if let newsArticle = self.getNews(for: index) {
            NewsAppNavigator.shared.navigateToNewsDetails(newsArticle, presentationStyle: .push)
        }
    }
    
    func numberOfRows() -> Int {
        return newsArticles.count
    }
}
