//
//  APIClient.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 30/12/23.
//

import Foundation
import PromiseKit

class APIClient: NSObject {
    static let shared = APIClient()
    private lazy var urlSession: URLSession = {
            let configuration = URLSessionConfiguration.default
            return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        }()
    
    private override init() {
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

            urlSession.dataTask(with: request) { (data, response, error) in
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
                    #if DEBUG
                    let backToString = String(data: data, encoding: String.Encoding.utf8)
                    print(backToString ?? "")
                    #endif
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
    
    func downloadImage(from url: URL) -> Promise<Data> {
        return Promise { seal in
            
            let task = urlSession.dataTask(with: url) { data, _, error in
                if let error = error {
                    seal.reject(error)
                    return
                }

                guard let imageData = data else {
                    seal.reject(APIError.invalidResponse)
                    return
                }

                seal.fulfill(imageData)
            }

            task.resume()
        }
    }
}

extension APIClient: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                let credential = URLCredential(trust: serverTrust)
                completionHandler(.useCredential, credential)
                return
            }
        }
        completionHandler(.performDefaultHandling, nil)
    }
}



