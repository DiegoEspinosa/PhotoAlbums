//
//  CustomImageView.swift
//  PhotoAlbums
//
//  Created by Diego Espinosa on 10/5/19.
//  Copyright © 2019 Diego Espinosa. All rights reserved.
//
//  Made modifications to custom class soultion on stackoverflow:
//  https://stackoverflow.com/questions/40873685/how-to-cache-images-using-urlsession-in-swift
//

import Foundation
import UIKit

class CustomImageView: UIImageView {
    let imageCache = NSCache<NSString, UIImage>()
    
    var imageUrlString : String?
    
    func loadImageFrom(urlString: String) {
        imageUrlString = urlString
        let url = URL(string: urlString)!
        image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            NSLog(String(imageCache.object(forKey: urlString as NSString)!.description))
            self.image = cachedImage
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data)
                    if self.imageUrlString == urlString {
                        self.image = imageToCache
                    }
                    self.imageCache.setObject(imageToCache!, forKey: url.absoluteString as NSString)
                }
            }.resume()
        }
    }
}
