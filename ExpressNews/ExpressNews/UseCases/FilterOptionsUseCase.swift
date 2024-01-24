//
//  FilterOptionsAPI.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 03/01/24.
//

import Foundation
import PromiseKit

class FilterOptionsUseCase: FilterOptionsUseCaseProtocol {

    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchSources() -> Promise<SourcesResponse> {
        return apiClient.fetchData(from: APIConstants.EndPoints.sources)
    }

    func loadCountries() -> Promise<[Country]> {
        return DataProvider.loadJSONFile(from: APIConstants.LocalJson.countries)
    }

    func loadLanguages() -> Promise<[Language]> {
        return DataProvider.loadJSONFile(from:  APIConstants.LocalJson.languages)
    }
    func loadCategories() -> Promise<[String]> {
        return DataProvider.loadJSONFile(from:  APIConstants.LocalJson.categories)
    }
    func loadFilterCategories() -> Promise<[String]> {
        return DataProvider.loadJSONFile(from:  APIConstants.LocalJson.filterCategories)
    }

}
