//
//  HomeViewModel.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 30/12/23.
//

import Foundation
import PromiseKit

final class HomeViewModel {
    private var featuredNews: [NewsArticle] = []
    private var categories: [String] = Constants.defaultCategories
    private var categorisedNews: [String: [NewsArticle]] = [:]

    private let homeNewsUseCase: HomeNewsUseCaseProtocol

    init(homeNewsUseCase: HomeNewsUseCaseProtocol = HomeNewsUseCase()) {
        self.homeNewsUseCase = homeNewsUseCase
    }
    
    // Fetch trending news for each category and collect responses in a dictionary
    func fetchTrendingNewsForCategories(parameters: [String: Any]?) -> Promise<[String: [NewsArticle]]> {
        var parametersWithCategory = parameters ?? [:]
        let promises = categories.map { category in
            parametersWithCategory[APIConstants.RequestParameters.category] = category.lowercased()
            return homeNewsUseCase.fetchTrendingNews(parameters: parametersWithCategory)
                .map { articles in
                    return (category, articles)
                }
        }

        return when(fulfilled: promises)
            .map {[weak self] categoryNewsArray in
                var categoryNewsDict: [String: [NewsArticle]] = [:]
                for (category, news) in categoryNewsArray {
                    categoryNewsDict[category] = news
                }
                self?.categorisedNews = categoryNewsDict
                return categoryNewsDict
            }
    }
    
    func fetchFeaturedNews(parameters: [String: Any]?) -> Promise<Void> {
        return firstly {
            homeNewsUseCase.fetchFeaturedNews(parameters: parameters)
        } .map { [weak self] articles in
            self?.featuredNews = articles
            return
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
    
    func didSelectRowAt(indexPath: IndexPath) {
        if indexPath.section != 0 {
            let news = self.getNewsForSection(section: indexPath.section)[indexPath.row]
            navigateToNewsDetails(news)
        }
    }
    
    private func navigateToNewsDetails(_ news: NewsArticle) {
        NewsAppNavigator.shared.navigateToNewsDetails(news, presentationStyle: .push)
    }
    
    func navigateToNewsList(for category: String) {
        NewsAppNavigator.shared.navigateToNewsList(for: category, presentationStyle: .push)
    }
    
    func getFeaturedNews() -> [NewsArticle] {
        return featuredNews
    }
    
    func numberOfSections() -> Int {
        return categories.count + 1
    }
    
    func getHeaderTitle(for section: Int) -> String {
        let index =  section - 1
        guard index >= 0, index < categories.count else {
            return ""
        }
        
        return categories[index]
    }
    
    func heightForHeaderInSection(_ section: Int) -> CGFloat {
        return section != 0 ?  Constants.CellHeights.categoryHeader : 0.0
    }
}
