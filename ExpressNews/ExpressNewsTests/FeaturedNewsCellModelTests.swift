//
//  FeaturedNewsCellModelTests.swift
//  ExpressNewsTests
//
//  Created by Kavita Thorat on 11/01/24.
//

import XCTest

final class FeaturedNewsCellModelTests: XCTestCase {
    
    var cellModel: FeaturedNewsCellViewModel!

    override func setUp() {
        super.setUp()
        cellModel = FeaturedNewsCellViewModel()
        let newsArticle1 = NewsArticle(source: ArticleSource(id: "the-washington-post", name: "The Washington Post"), author: "Jonathan Edwards", title: "13-year-old becomes first known person to ‘beat’ Tetris - The Washington Post", description: "Willis Gibson, 13, became the first person known to have beat “Tetris” by getting so far into the game he made it freeze.", url: "https://www.washingtonpost.com/nation/2024/01/04/13-year-old-beats-tetris/", urlToImage: "https://www.washingtonpost.com/wp-apps/imrs.php?src=https://d1i4t8bqe7zgj6.cloudfront.net/01-05-2024/t_01e058b5fa3f40aa8666709c2fa9fbbc_name_nintendo.jpg&w=1440", publishedAt: "2024-01-05T05:44:15Z", content: "Comment on this story\r\nComment\r\nAdd to your saved stories\r\nSave\r\nWillis Gibson spent more than a half-hour on Dec. 21 commanding a seemingly endless waterfall of blocks as they shot down his screen a… [+5348 chars]")
        
        let newsArticle2 = NewsArticle(source: ArticleSource(id: "the-washington-post", name: "The Washington Post"), author: "Jonathan Edwards", title: "13-year-old becomes first known person to ‘beat’ Tetris - The Washington Post", description: "Willis Gibson, 13, became the first person known to have beat “Tetris” by getting so far into the game he made it freeze.", url: "https://www.washingtonpost.com/nation/2024/01/04/13-year-old-beats-tetris/", urlToImage: "https://www.washingtonpost.com/wp-apps/imrs.php?src=https://d1i4t8bqe7zgj6.cloudfront.net/01-05-2024/t_01e058b5fa3f40aa8666709c2fa9fbbc_name_nintendo.jpg&w=1440", publishedAt: "2024-01-05T05:44:15Z", content: "Comment on this story\r\nComment\r\nAdd to your saved stories\r\nSave\r\nWillis Gibson spent more than a half-hour on Dec. 21 commanding a seemingly endless waterfall of blocks as they shot down his screen a… [+5348 chars]")
        let payload = [Constants.PayloadKeys.newsList: [newsArticle1, newsArticle2]]

        cellModel.configure(payload: payload)
    }
    override func tearDown() {
        cellModel = nil
        super.tearDown()
    }
    
    func testConfigureWithValidPayload() {
        XCTAssertEqual(cellModel.getNumberOfRows(), 2)
        XCTAssertNotNil(cellModel.getNewsForRow(index: 0))
        XCTAssertNil(cellModel.getNewsForRow(index: 4))
    }

    func testConfigureWithEmptyPayload() {
        let payload: [String: Any] = [Constants.PayloadKeys.newsList: []]
        cellModel.configure(payload: payload)

        XCTAssertEqual(cellModel.getNumberOfRows(), 0)
        XCTAssertNil(cellModel.getNewsForRow(index: 0))
    }
}
