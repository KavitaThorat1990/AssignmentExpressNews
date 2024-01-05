//
//  MockNewsAPI.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 05/01/24.
//

import PromiseKit

class MockNewsUseCase: NewsUseCase {
    func fetchFeaturedNews(parameters: [String: Any]?) -> Promise<NewsResponse> {
        return mockPromise(for: "news")
    }

    func fetchNews(parameters: [String: Any]?) -> Promise<NewsResponse> {
        return mockPromise(for: "news")
    }

    func fetchTrendingNews(parameters: [String: Any]?) -> Promise<NewsResponse> {
        return mockPromise(for: "news")
    }

    private func mockPromise<T: Codable>(for filename: String) -> Promise<T> {
        let filename = "\(filename)"
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            return Promise(error: MockAPIError.mockFileNotFound)
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let result = try decoder.decode(T.self, from: data)
            return Promise.value(result)
        } catch {
            return Promise(error: error)
        }
    }
}
