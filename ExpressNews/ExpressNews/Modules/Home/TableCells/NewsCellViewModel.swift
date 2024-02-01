//
//  NewsCellViewModel.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 12/01/24.
//

import UIKit
import PromiseKit

final class NewsCellViewModel: ObservableObject {
    private let news: NewsArticle
    @Published var downloadedImage: UIImage = UIImage(systemName: Constants.ImageNames.placeholder) ?? UIImage()
    private let imageUseCase: ImageUseCaseProtocol
    
    init(news: NewsArticle, imageUseCase: ImageUseCaseProtocol = ImageUseCase()) {
        self.news = news
        self.imageUseCase = imageUseCase
        loadImage()
    }
    
    private func loadImage() {
        guard let url = news.imageUrl else {
            return
        }
        
        imageUseCase.loadImage(from: url)
        .done {[weak self] image in
            self?.downloadedImage = image
        }
        .catch { _ in
        }
    }
    
    func getNews() -> NewsArticle {
        return news
    }
    
    func newsTitle() -> String {
        return news.title
    }
    
    func newsAuthorAndSource() -> String {
        return news.authorAndSource
    }
    
}
