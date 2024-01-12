//
//  NewsCellViewModelTests.swift
//  ExpressNewsTests
//
//  Created by Kavita Thorat on 12/01/24.
//

import XCTest

final class NewsCellViewModelTests: XCTestCase {

    func testInitialization() {
        let news = NewsArticle(source: ArticleSource(id: "the-washington-post", name: "The Washington Post"), author: "Jonathan Edwards", title: "13-year-old becomes first known person to ‘beat’ Tetris - The Washington Post", description: "Willis Gibson, 13, became the first person known to have beat “Tetris” by getting so far into the game he made it freeze.", url: "https://www.washingtonpost.com/nation/2024/01/04/13-year-old-beats-tetris/", urlToImage: "https://www.washingtonpost.com/wp-apps/imrs.php?src=https://d1i4t8bqe7zgj6.cloudfront.net/01-05-2024/t_01e058b5fa3f40aa8666709c2fa9fbbc_name_nintendo.jpg&w=1440", publishedAt: "2024-01-05T05:44:15Z", content: "Comment on this story\r\nComment\r\nAdd to your saved stories\r\nSave\r\nWillis Gibson spent more than a half-hour on Dec. 21 commanding a seemingly endless waterfall of blocks as they shot down his screen a… [+5348 chars]")
        let viewModel = NewsCellViewModel(news: news)
        XCTAssertEqual(viewModel.news, news, "News should be properly set during initialization.")
    }
}
