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
    func fetchAllAlbums() -> Promise<[Album]>
}

class PhotoAlbumSingleton: PhotoAlbumRepository {
    static let shared = PhotoAlbumSingleton()
    
    private let session = Alamofire.Session()
    
    private let urlString = "http://jsonplaceholder.typicode.com/photos"
    
    private init () {}
    
    func fetchAllAlbums() -> Promise<[Album]> {
        return Promise { seal in
            let url = URL(string: urlString)!
            _ = session.request(url, method: .get).response {response in
                if let jsonData = response.data {
                    do {
                        let jsonDecoder = JSONDecoder()
                        let json = try jsonDecoder.decode([PhotoJson].self, from: jsonData)
                        let photoArray = self.createPhotosFromJson(from: json)
                        let albums = self.createAlbumsFromPhotos(from: photoArray)
                        seal.fulfill(albums)
                    } catch {
                        print("Big Error: \(error)")
                        seal.reject(error)
                    }
                }
                if let error = response.error {
                    seal.reject(error)
                }
            }
        }
    }
    
    private func getNumberOfAlbumsFromJson(from photoJsonArray: [PhotoJson]) -> Int {
        var albumCount = 0
        var currentId = -1
        for photoJson in photoJsonArray {
            if(photoJson.albumId != currentId) {
                currentId = photoJson.albumId
                albumCount += 1
            }
        }
        return albumCount
    }
    
    private func createPhotosFromJson(from photoJsonArray: [PhotoJson]) -> [Photo] {
        
    }
    
    private func createAlbumsFromPhotos(from photoArray: [Photo]) -> [Album] {
        
    }
}
