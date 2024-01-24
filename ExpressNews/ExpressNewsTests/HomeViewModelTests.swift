//
//  HomeViewModelTests.swift
//  ExpressNewsTests
//
//  Created by Kavita Thorat on 05/01/24.
//

import XCTest

final class HomeViewModelTests: XCTestCase {

    var viewModel = HomeViewModel(homeNewsUseCase: MockHomeNewsUseCase())

    func testFetchFeaturedNews() {
        let expectation = self.expectation(description: "Fetch Trending News")

        viewModel.fetchFeaturedNews(parameters: nil)
            .done { [weak self] in
                XCTAssertEqual(self?.viewModel.getFeaturedNews().count ?? 0, 5)
                expectation.fulfill()
            }
            .catch { error in
                XCTFail("Error: \(error)")
                expectation.fulfill()
            }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchTrendingNewsForCategories() {

        let expectation = self.expectation(description: "Fetch Trending News for Categories")

        viewModel.fetchTrendingNewsForCategories(parameters: nil)
            .done {[weak self] categorisedNews in
                XCTAssertEqual(categorisedNews.count, 2)
                
                var numberOfRows = self?.viewModel.numberOfRowsForSection(section: 1)
                XCTAssertEqual(numberOfRows, 5)
                
                numberOfRows = self?.viewModel.numberOfRowsForSection(section: 0)
                XCTAssertEqual(numberOfRows, 0)
                
                numberOfRows = self?.viewModel.numberOfRowsForSection(section: 4)
                XCTAssertEqual(numberOfRows, 0)
                
                expectation.fulfill()
            }
            .catch { error in
                XCTFail("Error: \(error)")
                expectation.fulfill()
            }

        waitForExpectations(timeout: 5, handler: nil)
    }
}
