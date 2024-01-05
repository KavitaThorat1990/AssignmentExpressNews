//
//  FilterViewModelTests.swift
//  ExpressNewsTests
//
//  Created by Kavita Thorat on 05/01/24.
//

import XCTest

final class FilterViewModelTests: XCTestCase {
    var viewModel: FilterViewModel!

    override func setUp() {
        super.setUp()
        viewModel = FilterViewModel(filterOptionsUseCase: MockFilterOptionsUseCase())
    }
    
    func loadMockCategories() {
        let initialCategories = [
            FilterCategory(title: "Category", options: [FilterOption(title: "Sports", isSelected: false, value: "Sports"), FilterOption(title: "Tech", isSelected: false, value: "Tech"), FilterOption(title: "Business", isSelected: false, value: "Business") ]),
            FilterCategory(title: "Language", options: [FilterOption(title: "English", isSelected: false, value: "English"), FilterOption(title: "Spanish", isSelected: false, value: "Spanish"), FilterOption(title: "Hindi", isSelected: false, value: "Hindi"), FilterOption(title: "Urdu", isSelected: false, value: "Urdu") ]),
            FilterCategory(title: "Country", options: [FilterOption(title: "India", isSelected: false, value: "India"), FilterOption(title: "US", isSelected: false, value: "US"), FilterOption(title: "UK", isSelected: false, value: "UK"), FilterOption(title: "Iran", isSelected: false, value: "Iran") ]),
            FilterCategory(title: "Sources", options: [FilterOption(title: "ABC", isSelected: true, value: "ABC"), FilterOption(title: "XYZ", isSelected: false, value: "XYZ")])
        ]
        viewModel.categories = initialCategories
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

func testSetupCategories() {
        let expectation = XCTestExpectation(description: "Setup categories")

        viewModel.filterOptionsUpdated = {
            XCTAssertEqual(self.viewModel.numberOfCategories(), 4) // Adjust based on your expected category count
            XCTAssertEqual(self.viewModel.numberOfOptions(for: 0), 7) // Assuming initial options count is 0
            expectation.fulfill()
        }

        viewModel.setupCategories()

        wait(for: [expectation], timeout: 20.0)
    }
    
   func testDidSelectOption() {
       self.loadMockCategories()
       var indexPath = IndexPath(row: 0, section: 0)
       viewModel.didSelectOption(at: indexPath)
       XCTAssertTrue(viewModel.option(for: indexPath)?.isSelected ?? false)

   }
    
    func testNumberOfCategories() {
        self.loadMockCategories()
        let numberOfCategories = viewModel.numberOfCategories()
        XCTAssertEqual(numberOfCategories, 4)
    }

    func testCategoryTitle() {
        self.loadMockCategories()
        viewModel.selectedCategoryIndex = 1
        var categoryTitle = viewModel.categoryTitle(for: 1)
        XCTAssertEqual(categoryTitle, "Language")
        
        categoryTitle = viewModel.categoryTitle(for: 10)
        XCTAssertEqual(categoryTitle, "")
    }

    func testNumberOfOptions() {
        self.loadMockCategories()
        viewModel.selectedCategoryIndex = 0
        var numberOfOptions = viewModel.numberOfOptions(for: 0)
        XCTAssertEqual(numberOfOptions, 3)
        
        numberOfOptions = viewModel.numberOfOptions(for: 10)
        XCTAssertEqual(numberOfOptions, 0)
    }

    func testOption() {
        self.loadMockCategories()
        viewModel.selectedCategoryIndex = 1

        var indexPath = IndexPath(row: 1, section: 0)
        var option = viewModel.option(for: indexPath)

        XCTAssertEqual(option?.title ?? "", "Spanish")
        
        indexPath = IndexPath(row: 10, section: 0)
        option = viewModel.option(for: indexPath)

        XCTAssertNil(option)
    }
    
    func testGetSelectedOptions() {
        self.loadMockCategories()
        let selectedOptions = viewModel.getSelectedOptions()
        XCTAssertEqual(selectedOptions["Sources"]?.count, 1)
        XCTAssertEqual(selectedOptions["Country"]?.count, 0)

    }
    
    func testClearAllFilters() {
        self.loadMockCategories()
        viewModel.clearAllFilters()
        let selectedOptions = viewModel.getSelectedOptions()
        XCTAssertEqual(selectedOptions["Sources"]?.count, 0)
        XCTAssertEqual(selectedOptions["Country"]?.count, 0)
    }
}
