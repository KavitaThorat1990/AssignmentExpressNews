//
//  MockFilterOptionsUseCase.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 05/01/24.
//

import Foundation

import PromiseKit

class MockFilterOptionsAPI: FilterOptionsUseCase {
    var shouldFail: Bool!
    
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
    
    func loadFilterCategories() -> Promise<[String]> {
        if shouldFail {
            return Promise { seal in
                seal.reject(MockAPIError.mockFileNotFound)}
        }
        return DataProvider.loadJSONFile(from: "filterCategories")
    }

    func loadCategories() -> Promise<[String]> {
        if shouldFail {
            return Promise { seal in
                seal.reject(MockAPIError.mockFileNotFound)}
        }
        return DataProvider.loadJSONFile(from: "categories")
    }

    func loadCountries() -> Promise<[Country]> {
        if shouldFail {
            return Promise { seal in
                seal.reject(MockAPIError.mockFileNotFound)}
        }
        return DataProvider.loadJSONFile(from: "countries")
    }

    func loadLanguages() -> Promise<[Language]> {
        if shouldFail {
            return Promise { seal in
                seal.reject(MockAPIError.mockFileNotFound)}
        }
        return DataProvider.loadJSONFile(from: "languages")
    }

    func fetchSources() -> Promise<SourcesResponse> {
        if shouldFail {
            return Promise { seal in
                seal.reject(MockAPIError.mockFileNotFound)}
        }
        return DataProvider.loadJSONFile(from: "sourcesResponse")
    }
}

