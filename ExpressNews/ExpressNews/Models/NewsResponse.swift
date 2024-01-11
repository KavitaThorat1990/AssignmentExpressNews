//
//  NewsResponse.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 31/12/23.
//

import Foundation

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [NewsArticle]
}
