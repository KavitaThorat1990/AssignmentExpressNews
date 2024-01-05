//
//  NewsDetailsViewModel.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 03/01/24.
//

import Foundation

class NewsDetailsViewModel {
    var newsArticle: NewsArticle?
    var updateUI: (() -> Void)?
    
    func configure(payload: [String: Any]) {
        if let newsArticle = payload[Constants.PayloadKeys.newsArticle] as? NewsArticle{
            self.newsArticle = newsArticle
        }
    }
}
