//
//  APIConstants.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 04/01/24.
//

import Foundation

struct APIConstants {
    
    struct Header {
        static let apiKeyHeader = "X-Api-Key"
    }
    
    struct EndPoints {
        static let topHeadlines = "/top-headlines"
        static let everything = "/everything"
        static let sources = "/top-headlines/sources"
    }
    
    struct LocalJson {
        static let countries = "countries"
        static let languages = "languages"
        static let categories = "categories"
        static let filterCategories = "filterCategories"
    }
    
    struct RequestParameters {
        static let category = "category"
        static let country = "country"
        static let language = "language"
        static let pageSize = "pageSize"
        static let page = "page"
        static let sortBy = "sortBy"
        static let query = "q"
        static let sources = "sources"
    }
}

