//
//  NewsDetailsViewModel.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 03/01/24.
//

import UIKit
import PromiseKit

final class NewsDetailsViewModel: ObservableObject {
    private var newsArticle: NewsArticle?
    @Published var downloadedImage: UIImage?
    private let imageUseCase: ImageUseCaseProtocol
    
    init(newsArticle: NewsArticle? = nil, imageUseCase: ImageUseCaseProtocol = ImageUseCase()) {
        self.newsArticle = newsArticle
        self.imageUseCase = imageUseCase
        loadImage()
    }
    
    func configure(payload: [String: Any]) {
        if let newsArticle = payload[Constants.PayloadKeys.newsArticle] as? NewsArticle{
            self.newsArticle = newsArticle
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let url = newsArticle?.imageUrl else {
            return
        }
        
        imageUseCase.loadImage(from: url)
        .done {[weak self] image in
            self?.downloadedImage = image
        }
        .catch { _ in
        }
    }
    
    func newsImageUrl() -> URL? {
        return newsArticle?.imageUrl
    }
    
    func newsTitle() -> String {
        return newsArticle?.title ?? ""
    }
    
    func newsPublishedAt() -> String {
        return newsArticle?.updatedAt ?? ""
    }
    
    func newsAuthorAndSource() -> String {
        return newsArticle?.authorAndSource ?? ""
    }
    
    func newsContent() -> String? {
        return newsArticle?.content
    }
    
    func newsDescription() -> String? {
        return newsArticle?.description
    }
    
    func openNewsURL() {
        // open link in safari
        if let urlStr = newsArticle?.url, let url = URL(string: urlStr) {
            NewsAppNavigator.shared.openUrl(url)
        }
    }
    
    func newsUrl() -> String? {
        return newsArticle?.url
    }
}
