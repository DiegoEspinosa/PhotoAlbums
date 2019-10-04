//
//  UIImageView+DownloadImage.swift
//  PhotoAlbums
//
//  Created by Diego Espinosa on 10/2/19.
//  Copyright © 2019 Diego Espinosa. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadImage(from url: URL, dispatchGroup: DispatchGroup?, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        if let dispatch = dispatchGroup {
            dispatch.enter()
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            if let dispatch = dispatchGroup {
                dispatch.leave()
            }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    
    func downloadImage(from link: String, dispatchGroup: DispatchGroup?, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadImage(from: url, dispatchGroup: dispatchGroup, contentMode: mode)
    }
}
