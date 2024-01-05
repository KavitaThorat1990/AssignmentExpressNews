//
//  NewsAPI.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 31/12/23.
//

import PromiseKit

class NewsAPI: NewsUseCase {

    func fetchFeaturedNews(parameters: [String: Any]?) -> Promise<NewsResponse> {
        return APIClient.shared.fetchDataWithParameters(from: APIConstants.EndPoints.topHeadlines, parameters: parameters ?? [:])
    }

    func fetchNews(parameters: [String: Any]?) -> Promise<NewsResponse> {
        return APIClient.shared.fetchDataWithParameters(from: APIConstants.EndPoints.everything, parameters: parameters ?? [:])
    }

    func fetchTrendingNews(parameters: [String: Any]?) -> Promise<NewsResponse> {
        return APIClient.shared.fetchDataWithParameters(from: APIConstants.EndPoints.topHeadlines, parameters: parameters ?? [:])
    }
}
