//
//  MockAPIError.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 05/01/24.
//

import Foundation

enum MockAPIError: Error {
    case mockFileNotFound
    case jsonParsingError(Error)
}
