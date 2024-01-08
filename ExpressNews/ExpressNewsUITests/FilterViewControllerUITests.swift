//
//  FilterViewControllerUITests.swift
//  ExpressNewsUITests
//
//  Created by Kavita Thorat on 08/01/24.
//

import XCTest
@testable import ExpressNews

final class FilterViewControllerUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testTapCategoryCell() {
        app.buttons["SeeAll"].firstMatch.tap()
        app.buttons["Filter"].tap() // Replace with your actual button identifier
        let categoryCells = app.descendants(matching: .table)["categoriesTableView"].cells
        let categoryCell = categoryCells.element(boundBy: 2)
        categoryCell.tap()
        
        let optionsCells = app.descendants(matching: .table)["optionsTableView"].cells
        
        XCTAssertEqual(categoryCells.count, 4)
        XCTAssertEqual(optionsCells.count, 14)
    }

    func testTapOptionCell() {
        app.buttons["SeeAll"].firstMatch.tap()
        app.buttons["Filter"].tap() // Replace with your actual button identifier
        let categoryCells = app.descendants(matching: .table)["categoriesTableView"].cells
        let categoryCell = categoryCells.element(boundBy: 2)
        categoryCell.tap()
        
        let optionsCells = app.descendants(matching: .table)["optionsTableView"].cells
        optionsCells.element(boundBy: 0).tap()
        optionsCells.element(boundBy: 2).tap()
        
        //test single selection
        XCTAssertEqual( optionsCells.element(boundBy: 0).isSelected, false)
        XCTAssertEqual( optionsCells.element(boundBy: 2).isSelected, true)
        
        
        //test multiple selection
        categoryCells.element(boundBy: 3).tap()
        let optionsCellsForCategories = app.descendants(matching: .table)["optionsTableView"].cells
        optionsCellsForCategories.element(boundBy: 0).tap()
        optionsCellsForCategories.element(boundBy: 2).tap()
        
        XCTAssertEqual( optionsCellsForCategories.element(boundBy: 0).isSelected, true)
        XCTAssertEqual( optionsCellsForCategories.element(boundBy: 2).isSelected, true)

    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }
}
