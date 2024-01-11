//
//  FeaturedNewsCellModel.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 11/01/24.
//

import Foundation

final class FeaturedNewsCellModel {
    var newsArticles: [NewsArticle] = []
    var updateUI: (() -> Void)?
    
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
}
