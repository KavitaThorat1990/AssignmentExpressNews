//
//  AppConfiguration.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 16/01/24.
//

import Foundation

final class AppConfiguration {
    struct Keys {
        static let baseUrl = "BASE_URL"
        static let apiKey = "API_KEY"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist file not found")
        }
        return dict
    }()
    
    static let baseURL: String = {
        guard let baseUrlString = infoDictionary[Keys.baseUrl] as? String else {
            fatalError("base url not set in plist")
        }
        return baseUrlString
    }()
    
    static let apiKey: String = {
        guard let apiKey = infoDictionary[Keys.apiKey] as? String else {
            fatalError(("api key not set in plist"))
        }
        return apiKey
    }()
}
