//
//  NewsCellViewModel.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 12/01/24.
//

import Foundation

final class NewsCellViewModel {
    private let news: NewsArticle
    init(news: NewsArticle) {
        self.news = news
    }
    
    func getNews() -> NewsArticle {
        return news
    }
    
    func newsImageUrl() -> URL? {
        return news.imageUrl
    }
    
    func newsTitle() -> String {
        return news.title
    }
    
    func newsAuthorAndSource() -> String {
        return news.authorAndSource
    }
    
}
