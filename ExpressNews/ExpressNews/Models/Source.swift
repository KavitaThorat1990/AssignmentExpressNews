//
//  Source.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 03/01/24.
//

import Foundation

struct SourcesResponse: Codable {
    let status: String
    let sources: [NewsSource]
}

struct NewsSource: Codable {
    let id: String
    let name: String
    let description: String
    let url: String
    let category: String
    let language: String
    let country: String
}
