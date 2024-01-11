//
//  NewsDetailsCell.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 04/01/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct NewsDetailView: View {
    var newsArticle: NewsArticle
    var openNewsURLClosure: (() -> Void)?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Text(newsArticle.title)
                    .font(.headline)
                    .lineLimit(nil)
                
                Text(newsArticle.authorAndSource)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(newsArticle.updatedAt)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                if let imageUrl = newsArticle.imageUrl {
                    WebImage(url: imageUrl)
                        .placeholder(Image(systemName: "photo"))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .clipped()
                        .cornerRadius(8)
                        .padding(.vertical, 8)
                }

                if let description = newsArticle.description {
                    Text(description)
                        .font(.body)
                        .foregroundColor(.primary)
                        .lineLimit(nil)
                }
                
                if let content = newsArticle.content {
                    Text(content)
                        .font(.body)
                        .foregroundColor(.primary)
                        .lineLimit(nil)
                }

                HStack {
                    Spacer()
                    Button(Constants.ButtonTitles.seeMore) {
                        openNewsURLClosure?()
                    }
                    .foregroundColor(.blue)
                    .padding(.top, 8)
                }
            }
        }
        .padding(.horizontal, 16)
        .background(Color.white)
        .padding(.top, 15)
    }
}

#Preview {
    NewsDetailView(newsArticle: NewsArticle(source: ArticleSource(id: "the-washington-post", name: "The Washington Post"), author: "Jonathan Edwards", title: "13-year-old becomes first known person to ‘beat’ Tetris - The Washington Post", description: "Willis Gibson, 13, became the first person known to have beat “Tetris” by getting so far into the game he made it freeze.", url: "https://www.washingtonpost.com/nation/2024/01/04/13-year-old-beats-tetris/", urlToImage: "https://www.washingtonpost.com/wp-apps/imrs.php?src=https://d1i4t8bqe7zgj6.cloudfront.net/01-05-2024/t_01e058b5fa3f40aa8666709c2fa9fbbc_name_nintendo.jpg&w=1440", publishedAt: "2024-01-05T05:44:15Z", content: "Comment on this story\r\nComment\r\nAdd to your saved stories\r\nSave\r\nWillis Gibson spent more than a half-hour on Dec. 21 commanding a seemingly endless waterfall of blocks as they shot down his screen a… [+5348 chars]"))
}
