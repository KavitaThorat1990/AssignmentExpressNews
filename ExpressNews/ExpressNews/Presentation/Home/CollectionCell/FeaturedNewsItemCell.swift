//
//  FeaturedNewsItemCell.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 30/12/23.
//

import SDWebImage
import SDWebImageSwiftUI
import SwiftUI

struct FeaturedNewsItemCell: View {
    var news: NewsArticle
    @State private var titleHeight: CGFloat = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            if let imageUrl = news.imageUrl {
                WebImage(url:imageUrl)
                    .placeholder( Image(systemName: "photo.fill"))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: 200)
            } else {
                Image(systemName: "photo.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .foregroundColor(.gray)
            }
            
            NewsTitleView(title: news.title)
                .background(
                    GeometryReader { geometry in
                        Color.clear.onAppear {
                            titleHeight = geometry.size.height
                        }
                    }
                )
                .offset(y: -titleHeight)
                .padding(.bottom, -80)
                .padding(.horizontal, 5)
        }
    }
}

#Preview {
    FeaturedNewsItemCell(news:  NewsArticle(source: ArticleSource(id: "the-washington-post", name: "The Washington Post"), author: "Jonathan Edwards", title: "13-year-old becomes first known person to ‘beat’ Tetris - The Washington Post", description: "Willis Gibson, 13, became the first person known to have beat “Tetris” by getting so far into the game he made it freeze.", url: "https://www.washingtonpost.com/nation/2024/01/04/13-year-old-beats-tetris/", urlToImage: "https://www.washingtonpost.com/wp-apps/imrs.php?src=https://d1i4t8bqe7zgj6.cloudfront.net/01-05-2024/t_01e058b5fa3f40aa8666709c2fa9fbbc_name_nintendo.jpg&w=1440", publishedAt: "2024-01-05T05:44:15Z", content: "Comment on this story\r\nComment\r\nAdd to your saved stories\r\nSave\r\nWillis Gibson spent more than a half-hour on Dec. 21 commanding a seemingly endless waterfall of blocks as they shot down his screen a… [+5348 chars]"))
}
