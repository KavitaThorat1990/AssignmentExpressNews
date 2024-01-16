//
//  APIClient.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 30/12/23.
//

import Foundation
import PromiseKit

class APIClient {
    static let shared = APIClient()

    private init() {
        // Private initializer to ensure singleton
    }
    
    func fetchData<T: Codable>(from endpoint: String) -> Promise<T> {
        return fetchDataWithParameters(from: endpoint, parameters: [:])
    }

    func fetchDataWithParameters<T: Codable>(from endpoint: String, parameters: [String: Any]) -> Promise<T> {
        return Promise { seal in
            var urlString = AppConfiguration.baseURL + endpoint
            if !parameters.isEmpty {
                urlString += "?" + parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
            }

            guard let url = URL(string: urlString) else {
                seal.reject(APIError.invalidURL)
                return
            }

            var request = URLRequest(url: url)
            request.addValue(AppConfiguration.apiKey, forHTTPHeaderField: APIConstants.Header.apiKeyHeader)

            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    seal.reject(APIError.requestFailed(error))
                    return
                }

                guard let data = data else {
                    seal.reject(APIError.invalidResponse)
                    return
                }

                do {
                    let decoder = JSONDecoder()
//                    var backToString = String(data: data, encoding: String.Encoding.utf8)
//                    print(backToString)
                    let result = try decoder.decode(T.self, from: data)
                    seal.fulfill(result)
                } catch {
                    // Return APIError for decoding errors
                    do {
                        let decoder = JSONDecoder()
                        let apiError = try decoder.decode(APIErrorResponse.self, from: data)
                        seal.reject(APIError.apiFailed(apiError))
                    } catch {
                        seal.reject(APIError.decodingFailed(error))
                    }
                }
            }.resume()
        }
    }
}
