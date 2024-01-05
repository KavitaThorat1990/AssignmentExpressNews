//
//  HomeViewModel.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 30/12/23.
//

import Foundation
import PromiseKit

class HomeViewModel {
    var featuredNews: [NewsArticle] = []
    
    var categories: [String] = Constants.defaultCategories
    var trendingNews: [NewsArticle] = []
    var categorisedNews: [String: [NewsArticle]] = [:]

    private let newsUseCase: NewsUseCase

    init(newsUseCase: NewsUseCase = NewsAPI()) {
        self.newsUseCase = newsUseCase
    }
    
    // Fetch trending news for each category and collect responses in a dictionary
    func fetchTrendingNewsForCategories(parameters: [String: Any]?) -> Promise<[String: [NewsArticle]]> {
        var parametersWithCategory = parameters ?? [:]
        let promises = categories.map { category in
            parametersWithCategory[APIConstants.RequestParameters.category] = category.lowercased()
            return newsUseCase.fetchTrendingNews(parameters: parametersWithCategory)
                .map { newsResponse in
                    return (category, newsResponse.articles)
                }
        }

        return when(fulfilled: promises)
            .map { categoryNewsArray in
                var categoryNewsDict: [String: [NewsArticle]] = [:]
                for (category, news) in categoryNewsArray {
                    categoryNewsDict[category] = news
                }
                self.categorisedNews = categoryNewsDict
                return categoryNewsDict
            }
    }
    
    func fetchFeaturedNews(parameters: [String: Any]?) -> Promise<[NewsArticle]> {
        return firstly {
            newsUseCase.fetchFeaturedNews(parameters: parameters)
        }.map { newsResponse in
            self.featuredNews = newsResponse.articles
            return self.featuredNews
        }
    }
    
    func numberOfRowsForSection(section: Int) -> Int {
        return getNewsForSection(section: section).count
    }
    
    func getNewsForSection(section: Int) -> [NewsArticle] {
        guard section > 0, section - 1 < categories.count else {
            return []
        }
        let category = categories[section - 1]
        
        if let news = categorisedNews[category] {
            return news
        }
        return []
    }
}
