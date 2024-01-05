//
//  MockFilterOptionsUseCase.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 05/01/24.
//

import Foundation

import PromiseKit

class MockFilterOptionsUseCase: FilterOptionsUseCase {
    func loadFilterCategories() -> Promise<[String]> {
        return loadJSONFile(named: "filterCategories")
    }

    func loadCategories() -> Promise<[String]> {
        return loadJSONFile(named: "categories")
    }

    func loadCountries() -> Promise<[Country]> {
        return loadJSONFile(named: "countries")
    }

    func loadLanguages() -> Promise<[Language]> {
        return loadJSONFile(named: "languages")
    }

    func fetchSources() -> Promise<SourcesResponse> {
        return loadJSONFile(named: "sourcesResponse")
    }

    // Helper method to load JSON files
    private func loadJSONFile<T: Decodable>(named fileName: String) -> Promise<T> {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            return Promise(error: MockAPIError.mockFileNotFound)
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let result = try decoder.decode(T.self, from: data)
            return Promise.value(result)
        } catch {
            return Promise(error: MockAPIError.jsonParsingError(error))
        }
    }
}

