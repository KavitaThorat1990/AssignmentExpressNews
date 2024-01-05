//
//  SearchNewsViewModelTests.swift
//  ExpressNewsTests
//
//  Created by Kavita Thorat on 05/01/24.
//

import XCTest

final class SearchNewsViewModelTests: XCTestCase {
    var viewModel: SearchNewsViewModel!

    override func setUp() {
        super.setUp()
        viewModel = SearchNewsViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testGetAPIParameters() {
        viewModel.selectedQuery = "Apple"
        viewModel.selectedFilterOptions = ["language": ["en"]]

        let apiParameters = viewModel.getAPIParameters()

        XCTAssertEqual(apiParameters[APIConstants.RequestParameters.query] as? String, "Apple")
        XCTAssertEqual(apiParameters[APIConstants.RequestParameters.language] as? String, "en")
    }

}
