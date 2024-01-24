//
//  HomeNewsUseCaseProtocol.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 23/01/24.
//

import PromiseKit

protocol HomeNewsUseCaseProtocol {
    func fetchFeaturedNews(parameters: [String: Any]?) -> Promise<[NewsArticle]>
    func fetchTrendingNews(parameters: [String: Any]?) -> Promise<[NewsArticle]>
}
