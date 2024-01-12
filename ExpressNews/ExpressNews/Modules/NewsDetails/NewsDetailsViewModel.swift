//
//  NewsDetailsViewModel.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 03/01/24.
//

import Foundation

final class NewsDetailsViewModel {
    var newsArticle: NewsArticle?
    var openNewsURLClosure: (() -> Void)?
    
    init(newsArticle: NewsArticle? = nil, openNewsURLClosure: (() -> Void)? = nil) {
        self.newsArticle = newsArticle
        self.openNewsURLClosure = openNewsURLClosure
    }

    
    func configure(payload: [String: Any]) {
        if let newsArticle = payload[Constants.PayloadKeys.newsArticle] as? NewsArticle{
            self.newsArticle = newsArticle
        }
    }
}
