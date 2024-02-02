//
//  StringExtensionTests.swift
//  ExpressNewsTests
//
//  Created by Kavita Thorat on 05/01/24.
//

import XCTest

final class StringExtensionTests: XCTestCase {

    func testFormatDateString_ValidDateString_ReturnsFormattedString() {
        let dateString = "2023-01-01T12:34:56Z"
        let expectedFormattedString = "6.04 PM GMT+5:30, Sunday, Jan 1, 2023"

        let formattedString = dateString.formatDateString()
        XCTAssertEqual(formattedString, expectedFormattedString)
    }

    func testFormatDateString_InvalidDateString_ReturnsOriginalString() {
        let invalidDateString = "InvalidDateString"
        
        let formattedString = invalidDateString.formatDateString()
        XCTAssertEqual(formattedString, invalidDateString)
    }
}
