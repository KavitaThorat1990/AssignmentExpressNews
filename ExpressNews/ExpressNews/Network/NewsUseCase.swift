//
//  NewsUseCase.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 30/12/23.
//

import Foundation
import PromiseKit

protocol NewsUseCase {
    func fetchFeaturedNews(parameters: [String: Any]?) -> Promise<NewsResponse>
    func fetchNews(parameters: [String: Any]?) -> Promise<NewsResponse>
    func fetchTrendingNews(parameters: [String: Any]?) -> Promise<NewsResponse>
}
