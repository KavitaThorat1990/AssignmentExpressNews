//
//  NewsUseCase.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 30/12/23.
//

import Foundation
import PromiseKit

protocol NewsUseCaseProtocol {
    func fetchNews(parameters: [String: Any]?) -> Promise<[NewsArticle]>
}
