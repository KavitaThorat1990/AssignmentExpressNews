//
//  NewsCell.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 31/12/23.
//

import SDWebImage
import SDWebImageSwiftUI
import SwiftUI

struct NewsCell: View {
    var cellViewModel: NewsCellViewModel

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            // Image View
            if let imageUrl = cellViewModel.news.imageUrl {
                WebImage(url: imageUrl)
                    .placeholder(Image(systemName: Constants.ImageNames.placeholder))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
            } else {
                Image(systemName: Constants.ImageNames.placeholder)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                    .foregroundColor(.gray)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(cellViewModel.news.title)
                    .font(.headline)
                    .foregroundColor(.black)
                    .lineLimit(3)
                Text(cellViewModel.news.authorAndSource)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
        }
        .padding(0)
    }
}

#Preview {
    NewsCell(cellViewModel: NewsCellViewModel(news: NewsArticle(source: ArticleSource(id: "the-washington-post", name: "The Washington Post"), author: "Jonathan Edwards", title: "13-year-old becomes first known person to ‘beat’ Tetris - The Washington Post", description: "Willis Gibson, 13, became the first person known to have beat “Tetris” by getting so far into the game he made it freeze.", url: "https://www.washingtonpost.com/nation/2024/01/04/13-year-old-beats-tetris/", urlToImage: "https://www.washingtonpost.com/wp-apps/imrs.php?src=https://d1i4t8bqe7zgj6.cloudfront.net/01-05-2024/t_01e058b5fa3f40aa8666709c2fa9fbbc_name_nintendo.jpg&w=1440", publishedAt: "2024-01-05T05:44:15Z", content: "Comment on this story\r\nComment\r\nAdd to your saved stories\r\nSave\r\nWillis Gibson spent more than a half-hour on Dec. 21 commanding a seemingly endless waterfall of blocks as they shot down his screen a… [+5348 chars]")))
}
