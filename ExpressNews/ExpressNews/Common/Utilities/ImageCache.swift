//
//  ImageCache.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 01/02/24.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()
    private let maxItemsCount = 200
    private init() {
        // Private initializer to ensure singleton
    }
    
    private var cache = NSCache<NSString, UIImage>()
    private var accessOrder: [NSString] = []
    
    
    func getImage(for key: String) -> UIImage? {
        if let image = cache.object(forKey: key as NSString) {
            updateAccessOrder(key as NSString)
            return image
        }
        return nil
    }

    func setImage(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
        updateAccessOrder(key as NSString)
        removeExcessItems()
    }
    
    private func updateAccessOrder(_ key: NSString) {
        if let index = accessOrder.firstIndex(of: key) {
           accessOrder.remove(at: index)
        }
        accessOrder.append(key)
    }

    private func removeExcessItems() {
        let itemsToRemove = max(0, cache.totalCostLimit - maxItemsCount)
        for _ in 0..<itemsToRemove {
            if let key = accessOrder.first {
               cache.removeObject(forKey: key)
               accessOrder.removeFirst()
            }
        }
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}
