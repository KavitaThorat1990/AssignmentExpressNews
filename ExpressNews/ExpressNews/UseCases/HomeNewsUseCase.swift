//
//  HomeNewsUseCase.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 23/01/24.
//

import PromiseKit

class HomeNewsUseCase: HomeNewsUseCaseProtocol {

    func fetchFeaturedNews(parameters: [String: Any]?) -> Promise<[NewsArticle]> {
        
        let promise: Promise<NewsResponse> = {
            APIClient.shared.fetchDataWithParameters(from: APIConstants.EndPoints.topHeadlines, parameters: parameters ?? [:])
        }()
        
        return firstly {
            promise
        }.map { response in
            return response.articles
        }
    }

    func fetchTrendingNews(parameters: [String: Any]?) -> Promise<[NewsArticle]> {
        let promise: Promise<NewsResponse> = {
            APIClient.shared.fetchDataWithParameters(from: APIConstants.EndPoints.topHeadlines, parameters: parameters ?? [:])
        }()
        
        return firstly {
            promise
        }.map { response in
            return response.articles
        }
    }
}
