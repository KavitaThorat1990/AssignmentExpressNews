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

class NewsListViewModel {
    var newsArticles: [NewsArticle] = []
    let sortingOptions: [SortOption] = [.relevancy, .popularity, .publishedAt]
    var selectedCategory: String = ""
    var selectedSortOption: SortOption = .publishedAt
    var selectedFilterOptions: [String: [String]] = [:]
    var currentPage: Int = 1
    private let pageSize: Int = Constants.pageSizeForNewsList
    private let newsUseCase: NewsUseCase

    init(newsUseCase: NewsUseCase = NewsAPI()) {
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
    
    func fetchNews(queryParam: [String: Any] = [:]) -> Promise<[NewsArticle]> {
        var parameters: [String: Any] = [APIConstants.RequestParameters.category : selectedCategory, APIConstants.RequestParameters.country: Constants.defaultCountry, APIConstants.RequestParameters.pageSize: pageSize, APIConstants.RequestParameters.page: currentPage, APIConstants.RequestParameters.sortBy: selectedSortOption.rawValue]
        parameters.merge(getAPIParameters()) { (_, new) in new }
        
        if let sources = parameters[APIConstants.RequestParameters.sources] as? String, sources.count > 0 {
            parameters.removeValue(forKey: APIConstants.RequestParameters.country)
            parameters.removeValue(forKey: APIConstants.RequestParameters.category)
        }
        return firstly {
            newsUseCase.fetchFeaturedNews(parameters: parameters)
        }.map {[weak self] newsResponse in
            self?.newsArticles.append(contentsOf: newsResponse.articles)
            self?.currentPage += 1  // Increment the page for the next request
            return self?.newsArticles ?? []
        }
    }
    
    func resetPagination() {
        currentPage = 1
        newsArticles.removeAll()
    }
    
    func handleSortSelection(option: SortOption) {
        self.selectedSortOption = option
    }
}
