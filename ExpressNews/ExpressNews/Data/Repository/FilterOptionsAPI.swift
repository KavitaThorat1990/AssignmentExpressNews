//
//  FilterOptionsAPI.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 03/01/24.
//

import Foundation
import PromiseKit

class FilterOptionsAPI: FilterOptionsUseCase {

    private let apiClient: APIClient
    private let dataProvider: DataProvider

    init(apiClient: APIClient = APIClient.shared, dataProvider: DataProvider = DataProvider()) {
        self.apiClient = apiClient
        self.dataProvider = dataProvider
    }

    func fetchSources() -> Promise<SourcesResponse> {
        return apiClient.fetchData(from: APIConstants.EndPoints.sources)
    }

    func loadCountries() -> Promise<[Country]> {
        return dataProvider.loadCategories(from: APIConstants.LocalJson.countries)
    }

    func loadLanguages() -> Promise<[Language]> {
        return dataProvider.loadCategories(from:  APIConstants.LocalJson.languages)
    }
    func loadCategories() -> Promise<[String]> {
        return dataProvider.loadCategories(from:  APIConstants.LocalJson.categories)
    }
    func loadFilterCategories() -> Promise<[String]> {
        return dataProvider.loadCategories(from:  APIConstants.LocalJson.filterCatgories)
    }

}
