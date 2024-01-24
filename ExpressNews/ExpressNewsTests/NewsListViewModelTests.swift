//
//  NewsListViewModelTests.swift
//  ExpressNewsTests
//
//  Created by Kavita Thorat on 05/01/24.
//

import XCTest

final class NewsListViewModelTests: XCTestCase {
    var viewModel: NewsListViewModel = NewsListViewModel(newsUseCase: MockNewsUseCase())

    func testConfigure() {
        let payload: [String: Any] = [Constants.PayloadKeys.category: "Technology"]

        viewModel.configure(payload: payload)

        XCTAssertEqual(viewModel.getSelectedCategory(), "Technology")
    }

    func testGetAPIParameters() {
        viewModel.setSelectedFilterOptions(selectedOptions: ["Language": ["English", "Spanish"]])

        let parameters = viewModel.getAPIParameters()

        if let selectedLanguages = parameters["language"] as? String {
            XCTAssertEqual(selectedLanguages, "english,spanish")
        }
    }

    func testFetchNews() {
        viewModel.setSelectedCategory("Technology")
        viewModel.handleSortSelection(option: .relevancy)
        viewModel.setSelectedFilterOptions(selectedOptions: ["Language": ["English", "Spanish"], "Category": ["Sports"]])
        
        let expectation = self.expectation(description: "Fetch Trending News")

        viewModel.fetchNews()
            .done { [weak self] in
                XCTAssertEqual(self?.viewModel.numberOfRows(), 5)
                expectation.fulfill()
            }
            .catch { error in
                XCTFail("Error: \(error)")
                expectation.fulfill()
            }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testResetPagination() {
        viewModel.resetPagination()

        XCTAssertEqual(viewModel.getCurrentPage(), 1)
        XCTAssertEqual(viewModel.numberOfRows(), 0)
    }

    func testHandleSortSelection() {
        viewModel.handleSortSelection(option: .popularity)
        viewModel.handleSortSelection(option: .relevancy)

        XCTAssertEqual(viewModel.getSelectedSortOption(), .relevancy)
    }

    
    func testSortOptionTitle() {
        viewModel.handleSortSelection(option: .popularity)
        XCTAssertEqual(viewModel.getSelectedSortOption().title(), "Popularity")
        XCTAssertEqual(SortOption.relevancy.title(), "Relevancy")
        XCTAssertEqual(SortOption.publishedAt.title(), "Published At")
    }
    
}
