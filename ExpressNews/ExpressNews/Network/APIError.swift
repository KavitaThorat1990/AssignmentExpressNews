//
//  APIError.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 04/01/24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    case invalidResource
    case apiFailed(APIErrorResponse)
}

struct APIErrorResponse: Codable {
    let status: String
    let message: String
    let code: String
}

