//
//  FilterViewModelTests.swift
//  ExpressNewsTests
//
//  Created by Kavita Thorat on 05/01/24.
//

import XCTest

final class FilterViewModelTests: XCTestCase {
    
    var viewModel = FilterViewModel(filterOptionsUseCase: MockFilterOptionsAPI())

    func testSetupCategories() {
        let expectation = self.expectation(description: "Fetch filter options")
        
        viewModel.filterOptionsLoaded = { [weak self] in
            XCTAssertEqual(self?.viewModel.numberOfCategories(), 4)
            XCTAssertEqual(self?.viewModel.numberOfOptions(for: 0), 7)
                
        //        testDidSelectOption
            var indexPath = IndexPath(row: 0, section: 0)
            self?.viewModel.didSelectOption(at: indexPath)
            XCTAssertTrue(self?.viewModel.option(for: indexPath)?.isSelected ?? false)
                
                
        //        testNumberOfCategories
            let numberOfCategories = self?.viewModel.numberOfCategories()
            XCTAssertEqual(numberOfCategories, 4)
                
                
        //        testCategoryTitle
            self?.viewModel.selectedCategoryIndex = 1
            var categoryTitle = self?.viewModel.categoryTitle(for: 1)
            XCTAssertEqual(categoryTitle, "Country")
                    
            categoryTitle = self?.viewModel.categoryTitle(for: 10)
            XCTAssertEqual(categoryTitle, "")
                
        //        testNumberOfOptions
            var numberOfOptions = self?.viewModel.numberOfOptions(for: 0)
            XCTAssertEqual(numberOfOptions, 7)
                
            numberOfOptions = self?.viewModel.numberOfOptions(for: 10)
            XCTAssertEqual(numberOfOptions, 0)
                
                
        //        testOption
            self?.viewModel.selectedCategoryIndex = 1

            indexPath = IndexPath(row: 1, section: 0)
            var option = self?.viewModel.option(for: indexPath)
            XCTAssertEqual(option?.title ?? "", "Argentina")
                
            indexPath = IndexPath(row: 100, section: 0)
            option = self?.viewModel.option(for: indexPath)
            XCTAssertNil(option)
                
        //        testGetSelectedOptions
                
            var selectedOptions = self?.viewModel.getSelectedOptions() ?? [:]
            XCTAssertEqual(selectedOptions["Category"]?.count, 1)
            XCTAssertEqual(selectedOptions["Country"]?.count, 0)
                
        //        testClearAllFilters
            self?.viewModel.clearAllFilters()
            selectedOptions = self?.viewModel.getSelectedOptions() ?? [:]
            XCTAssertEqual(selectedOptions["Sources"]?.count, 0)
            XCTAssertEqual(selectedOptions["Country"]?.count, 0)
            expectation.fulfill()
       }
        
       waitForExpectations(timeout: 5, handler: nil)
    }
}
