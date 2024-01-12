//
//  MockNewsAPI.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 05/01/24.
//

import Foundation
import PromiseKit

class MockNewsAPI: NewsUseCase {
    var shouldFail: Bool = false
    
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
    
    func fetchFeaturedNews(parameters: [String: Any]?) -> Promise<NewsResponse> {
        if shouldFail {
            return Promise { seal in
                seal.reject(MockAPIError.mockFileNotFound)}
        }
        return DataProvider.loadJSONFile(from: "news")
    }

    func fetchNews(parameters: [String: Any]?) -> Promise<NewsResponse> {
        if shouldFail {
            return Promise { seal in
                seal.reject(MockAPIError.mockFileNotFound)}
        }
        return DataProvider.loadJSONFile(from: "news")
    }

    func fetchTrendingNews(parameters: [String: Any]?) -> Promise<NewsResponse> {
        if shouldFail {
            return Promise { seal in
                seal.reject(MockAPIError.mockFileNotFound)}
        }
        return DataProvider.loadJSONFile(from: "news")
    }
}
