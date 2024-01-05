//
//  DataProvider.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 03/01/24.
//

import Foundation
import PromiseKit

class DataProvider {

    func loadCategories<T: Codable>(from fileName: String) -> Promise<T> {
        return Promise { seal in
            guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
                seal.reject(APIError.invalidResource)
                return
            }

            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let decoder = JSONDecoder()
                let categories = try decoder.decode(T.self, from: data)
                seal.fulfill(categories)
            } catch {
                seal.reject(error)
            }
        }
    }
}
