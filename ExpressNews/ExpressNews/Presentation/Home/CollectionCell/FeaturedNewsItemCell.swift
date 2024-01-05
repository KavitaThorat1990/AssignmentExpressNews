//
//  FeaturedNewsItemCell.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 30/12/23.
//

import UIKit
import SDWebImage

class FeaturedNewsItemCell: UICollectionViewCell, NibRegister {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with news: NewsArticle) {
        titleLabel.text = news.title
        if let url = news.imageUrl {
            imageView.sd_setImage(with: url)
        }
    }
}
