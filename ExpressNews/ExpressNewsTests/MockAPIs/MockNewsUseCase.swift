//
//  MockNewsAPI.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 05/01/24.
//

import Foundation
import PromiseKit

class MockNewsUseCase: NewsUseCaseProtocol {
    var shouldFail: Bool = false
    
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
    
    func fetchNews(parameters: [String: Any]?) -> Promise<[NewsArticle]> {
        if shouldFail {
            return Promise { seal in
                seal.reject(MockAPIError.mockFileNotFound)}
        }
        let promise: Promise<NewsResponse> = {
            DataProvider.loadJSONFile(from: "news")
        }()
        
        return firstly {
            promise
        }.map { response in
            return response.articles
        }
    }
}


class MockHomeNewsUseCase: HomeNewsUseCaseProtocol {
    var shouldFail: Bool = false
    
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
    
    func fetchFeaturedNews(parameters: [String: Any]?) -> Promise<[NewsArticle]> {
        if shouldFail {
            return Promise { seal in
                seal.reject(MockAPIError.mockFileNotFound)}
        }
        
        let promise: Promise<NewsResponse> = {
            DataProvider.loadJSONFile(from: "news")
        }()
        
        return firstly {
            promise
        }.map { response in
            return response.articles
        }
    }

    func fetchTrendingNews(parameters: [String: Any]?) -> Promise<[NewsArticle]> {
        if shouldFail {
            return Promise { seal in
                seal.reject(MockAPIError.mockFileNotFound)}
        }
        
        let promise: Promise<NewsResponse> = {
            DataProvider.loadJSONFile(from: "news")
        }()
        
        return firstly {
            promise
        }.map { response in
            return response.articles
        }
    }
}
