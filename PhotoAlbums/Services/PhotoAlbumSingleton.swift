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
    
    private func createPhotosFromJson(from photoJsonArray: [PhotoJson]) -> [Photo] {
        var allPhotos : Array<Photo> = []
        for photoJson in photoJsonArray {
            let newPhoto = Photo(photoJson.albumId, photoJson.id, photoJson.title, photoJson.url, photoJson.thumbnailUrl)
            allPhotos.append(newPhoto)
        }
        return allPhotos
    }
    
    private func createAlbumsFromPhotos(from photoArray: [Photo]) -> [Album] {
        
    }
    
    private func getNumberOfAlbumsFromAllPhotos(from photoArray: [Photo]) -> Int {
        var albumCount = 0
        var currentId = -1
        for photo in photoArray {
            if(photo.albumId != currentId) {
                currentId = photo.albumId
                albumCount += 1
            }
        }
        return albumCount
    }
}
