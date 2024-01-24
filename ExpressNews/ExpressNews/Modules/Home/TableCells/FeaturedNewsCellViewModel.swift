//
//  FeaturedNewsCellModel.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 11/01/24.
//

import Foundation

final class FeaturedNewsCellViewModel {
    private var newsArticles: [NewsArticle] = []
    
    init(newsArticles: [NewsArticle] = []) {
        self.newsArticles = newsArticles
    }

    func configure(payload: [String: Any]) {
        if let newsArticle = payload[Constants.PayloadKeys.newsList] as? [NewsArticle]{
            self.newsArticles = newsArticle
        }
    }
    
    func getNumberOfRows() -> Int {
        return newsArticles.count
    }
    
    func getNewsForRow(index: Int) -> NewsArticle? {
        guard index < newsArticles.count else {
            return nil
        }
        return newsArticles[index]
    }
    
    func didSelectItemAt(indexPath: IndexPath) {
        if let news = self.getNewsForRow(index: indexPath.item) {
            NewsAppNavigator.shared.navigateToNewsDetails(news, presentationStyle: .push)
        }
    }
}
