//
//  NewsDetailsCell.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 04/01/24.
//

import UIKit

class NewsDetailsCell: UITableViewCell, NibRegister {
    
    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var publishedAtLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var newsURLButton: UIButton!
    var openNewsURLClosure: (() -> Void)?


    func configure(with newsArticle: NewsArticle) {
        titleLabel.text = newsArticle.title
        authorLabel.text = newsArticle.authorAndSource
        publishedAtLabel.text = newsArticle.updatedAt
        descriptionLabel.text = newsArticle.description
        contentLabel.text = newsArticle.content

        if let url = newsArticle.imageUrl {
            newsImageView.sd_setImage(with: url, completed: nil)
        }
    }
    @IBAction private func openNewsURL() {
        // Handle opening news URL
        openNewsURLClosure?()
    }
}
