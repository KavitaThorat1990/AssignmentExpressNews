//
//  NewsDetailsUITests.swift
//  ExpressNewsUITests
//
//  Created by Kavita Thorat on 23/01/24.
//

import XCTest
@testable import ExpressNews

final class NewsDetailsUITests: XCTestCase {

    var app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }
    
    func testTapNewsCell() {
        app.buttons[Constants.AccessibilityIds.seeAllButton].firstMatch.tap()
        let newsCells = app.tables[Constants.AccessibilityIds.newsListTable].cells
        let newsCell = newsCells.element(boundBy: 2)
        newsCell.tap()
        let label = app.staticTexts["title"]
        XCTAssertTrue(label.value != nil)
        XCTAssertNotNil(app.buttons[Constants.AccessibilityIds.seeMoreButton].firstMatch)
   }
    
}
