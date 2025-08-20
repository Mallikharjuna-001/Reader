
//
//  ImageLoader.swift
//  Reader
//
//  Created by Mallikharjuna on 17/08/25.
//

import Foundation
import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    private let cache = NSCache<NSURL, UIImage>()

    func load(_ url: URL, into imageView: UIImageView) {
        if let cached = cache.object(forKey: url as NSURL) {
            imageView.image = cached
            return
        }
        imageView.image = nil
        let req = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        URLSession.shared.dataTask(with: req) { [weak self] data, _, _ in
            guard let data = data, let img = UIImage(data: data) else {
                return
            }
            self?.cache.setObject(img, forKey: url as NSURL)
            DispatchQueue.main.async { imageView.image = img }
        }.resume()
    }
}
