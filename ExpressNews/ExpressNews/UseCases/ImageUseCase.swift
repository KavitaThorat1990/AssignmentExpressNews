//
//  ImageUseCase.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 01/02/24.
//

import UIKit
import PromiseKit

class ImageUseCase: ImageUseCaseProtocol {
    func loadImage(from url: URL) -> Promise<UIImage> {
            return Promise { seal in
                // Check if the image is available in the cache
                if let cachedImage = ImageCache.shared.getImage(for: url.absoluteString) {
                    seal.fulfill(cachedImage)
                    return
                }

                APIClient.shared.downloadImage(from: url)
                    .done { imageData in
                        // Cache the downloaded image
                        guard let image = UIImage(data: imageData) else {
                            seal.reject(APIError.invalidResponse)
                            return
                        }
                        ImageCache.shared.setImage(image, for: url.absoluteString)
                        seal.fulfill(image)
                    }
                    .catch { error in
                        seal.reject(error)
                    }
            }
        }
}
