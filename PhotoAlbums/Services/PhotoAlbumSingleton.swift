//
//  PhotoAlbumSingleton.swift
//  PhotoAlbums
//
//  Created by Diego Espinosa on 10/2/19.
//  Copyright © 2019 Diego Espinosa. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

protocol PhotoAlbumRepository {
    //func fetchAllAlbums() -> Promise<[Album]>
}

class PhotoAlbumSingleton: PhotoAlbumRepository {
    static let shared = PhotoAlbumSingleton()
    
    private let session = Alamofire.Session()
    
    private let urlString = "http://jsonplaceholder.typicode.com/photos"
    
    private init () {}
    
    //func fetchAllAlbums() -> Promise<[Album]> {}
    
    private func getNumberOfAlbumsFromJson() {
        
    }
    
    private func createPhotosFromJson() {
        
    }
    
    private func createAlbumsFromPhotos() {
        
    }
}
