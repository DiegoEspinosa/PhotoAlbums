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
            session.request(url, method: .get).response {response in
                if let jsonData = response.data {
                    do {
                        let jsonDecoder = JSONDecoder()
                        let json = try jsonDecoder.decode([PhotoJson].self, from: jsonData)
                        let photoArray = self.createPhotosFromJson(from: json)
                        let albums = self.createAlbumsFromAllPhotos(from: photoArray)
                        seal.fulfill(albums)
                    } catch {
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
    
    private func createAlbumsFromAllPhotos(from photoArray: [Photo]) -> [Album] {
        var albums : Array<Album> = []
        var currentAlbumId = photoArray[0].albumId
        let maxNumAlbums = getNumberOfAlbumsFromAllPhotos(from: photoArray)
        while(currentAlbumId <= maxNumAlbums) {
            let newAlbum = Album(albumId: currentAlbumId)
            for photo in photoArray {
                if(photo.albumId == currentAlbumId) {
                    newAlbum.albumPhotos.append(photo)
                }
            }
            albums.append(newAlbum)
            currentAlbumId += 1
        }
        return albums
    }
    
    private func getNumberOfAlbumsFromAllPhotos(from photoArray: [Photo]) -> Int {
        var albumCount = 0
        var currentAlbumId = -1
        for photo in photoArray {
            if(photo.albumId != currentAlbumId) {
                currentAlbumId = photo.albumId
                albumCount += 1
            }
        }
        return albumCount
    }
}
