//
//  String+Extension.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 04/01/24.
//

import Foundation

extension String {
    func formatDateString() -> String {
        let inputDateFormatter = ISO8601DateFormatter()
        let outputDateFormatter = DateFormatter()

        if let date = inputDateFormatter.date(from: self) {
            outputDateFormatter.dateFormat = Constants.DateFormats.newsDateFormat
            outputDateFormatter.timeZone = TimeZone.current
            return outputDateFormatter.string(from: date)
        }

        return self
    }
}
