//
//  ImageUseCaseProtocol.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 01/02/24.
//

import UIKit
import PromiseKit

protocol ImageUseCaseProtocol {
    func loadImage(from url: URL) -> Promise<UIImage>
}
