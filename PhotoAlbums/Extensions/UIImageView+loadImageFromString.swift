//
//  UIImageView+loadImageFromString.swift
//  PhotoAlbums
//
//  Created by Diego Espinosa on 10/5/19.
//  Copyright © 2019 Diego Espinosa. All rights reserved.
//
//  Found solution to caching here
//  https://blewjy.github.io/ios/swift/4/basic/2019/02/27/image-caching-in-swift-4.html
//

import Foundation
import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageFromString(urlString: String){
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cacheImage
            return
        }
        guard let url = URL(string: urlString) else {return}
            
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let error = error {
                NSLog("Error: \(error)")
                return
            }
            guard let data = data else {return}
            let image = UIImage(data: data)
            imageCache.setObject(image!, forKey: urlString as AnyObject)
                
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
    
    func loadImageFromString(urlString: String, completion: @escaping ()->Void){
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cacheImage
            completion()
        }
        guard let url = URL(string: urlString) else {return}
            
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let error = error {
                NSLog("Error: \(error)")
                completion()
            }
            guard let data = data else {return}
            let image = UIImage(data: data)
            imageCache.setObject(image!, forKey: urlString as AnyObject)
                
            DispatchQueue.main.async {
                self.image = image
                completion()
            }
        }.resume()
    }
}
