//
//  NewsArticle.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 30/12/23.
//

import Foundation

struct NewsArticle: Codable {
    let source: ArticleSource
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    
    var authorAndSource: String {
        var authAndSource = "by "
        if let auth = author {
            authAndSource += (auth + ", ")
        }
        authAndSource += source.name
        return authAndSource
    }
    
    var updatedAt: String {
        return "updated at " + publishedAt.formatDateString()
    }
    
    var imageUrl: URL? {
        if let imageURL = urlToImage, let url = URL(string: imageURL) {
            return url
        }
        return nil
    }
}
