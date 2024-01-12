//
//  NewsListViewModelTests.swift
//  ExpressNewsTests
//
//  Created by Kavita Thorat on 05/01/24.
//

import XCTest

final class NewsListViewModelTests: XCTestCase {
    var viewModel: NewsListViewModel = NewsListViewModel(newsUseCase: MockNewsAPI())

    func testConfigure() {
        let payload: [String: Any] = [Constants.PayloadKeys.category: "Technology"]

        viewModel.configure(payload: payload)

        XCTAssertEqual(viewModel.selectedCategory, "Technology")
    }

    func testGetAPIParameters() {
        viewModel.selectedFilterOptions = ["Language": ["English", "Spanish"]]

        let parameters = viewModel.getAPIParameters()

        if let selectedLanguages = parameters["language"] as? String {
            XCTAssertEqual(selectedLanguages, "english,spanish")
        }
    }

    func testFetchNews() {
        viewModel.selectedCategory = "Technology"
        viewModel.selectedSortOption = .relevancy
        viewModel.selectedFilterOptions = ["Language": ["English", "Spanish"], "Category": ["Sports"]]
        
        let expectation = self.expectation(description: "Fetch Trending News")

        viewModel.fetchNews()
            .done { trendingNews in
                XCTAssertEqual(trendingNews.count, 5)
                expectation.fulfill()
            }
            .catch { error in
                XCTFail("Error: \(error)")
                expectation.fulfill()
            }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testResetPagination() {
        viewModel.currentPage = 5
        viewModel.newsArticles = [NewsArticle]()

        viewModel.resetPagination()

        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertTrue(viewModel.newsArticles.isEmpty)
    }

    func testHandleSortSelection() {
        viewModel.selectedSortOption = .popularity
        viewModel.handleSortSelection(option: .relevancy)

        XCTAssertEqual(viewModel.selectedSortOption, .relevancy)
    }

    
    func testSortOptionTitle() {
        viewModel.selectedSortOption = .popularity
        XCTAssertEqual(viewModel.selectedSortOption.title(), "Popularity")
        XCTAssertEqual(SortOption.relevancy.title(), "Relevancy")
        XCTAssertEqual(SortOption.publishedAt.title(), "Published At")
    }
    
}
