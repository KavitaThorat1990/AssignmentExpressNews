//
//  NewsAPI.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 31/12/23.
//

import PromiseKit

class NewsUseCase: NewsUseCaseProtocol {
    func fetchNews(parameters: [String: Any]?) -> Promise<[NewsArticle]> {
        let promise: Promise<NewsResponse> = {
            return APIClient.shared.fetchDataWithParameters(from: APIConstants.EndPoints.topHeadlines, parameters: parameters ?? [:])
        }()
        
        return firstly {
            promise
        }.map { response in
            return response.articles
        }
    }
}
