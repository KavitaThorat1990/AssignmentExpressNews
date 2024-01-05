//
//  NewsCell.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 31/12/23.
//

import UIKit
import SDWebImage

class NewsCell: UITableViewCell, NibRegister {

    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with news: NewsArticle) {
        titleLabel.text = news.title
        if let url = news.imageUrl {
            logoImageView.sd_setImage(with: url)
        }
    }
    
}
