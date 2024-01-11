//
//  FilterOptionsUseCase.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 03/01/24.
//

import PromiseKit

protocol FilterOptionsUseCase {
    func fetchSources() -> Promise<SourcesResponse>
    func loadCountries() -> Promise<[Country]>
    func loadLanguages() -> Promise<[Language]>
    func loadCategories() -> Promise<[String]>
    func loadFilterCategories() -> Promise<[String]>

}
