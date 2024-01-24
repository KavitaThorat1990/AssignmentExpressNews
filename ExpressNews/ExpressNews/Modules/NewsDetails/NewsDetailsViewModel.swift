//
//  NewsDetailsViewModel.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 03/01/24.
//

import Foundation

final class NewsDetailsViewModel {
    private var newsArticle: NewsArticle?
    
    init(newsArticle: NewsArticle? = nil) {
        self.newsArticle = newsArticle
    }

    
    func configure(payload: [String: Any]) {
        if let newsArticle = payload[Constants.PayloadKeys.newsArticle] as? NewsArticle{
            self.newsArticle = newsArticle
        }
    }
    
    func newsImageUrl() -> URL? {
        return newsArticle?.imageUrl
    }
    
    func newsTitle() -> String {
        return newsArticle?.title ?? ""
    }
    
    func newsPublishedAt() -> String {
        return newsArticle?.updatedAt ?? ""
    }
    
    func newsAuthorAndSource() -> String {
        return newsArticle?.authorAndSource ?? ""
    }
    
    func newsContent() -> String? {
        return newsArticle?.content
    }
    
    func newsDescription() -> String? {
        return newsArticle?.description
    }
    
    func openNewsURL() {
        // open link in safari
        if let urlStr = newsArticle?.url, let url = URL(string: urlStr) {
            NewsAppNavigator.shared.openUrl(url)
        }
    }
    
    func newsUrl() -> String? {
        return newsArticle?.url
    }
}
