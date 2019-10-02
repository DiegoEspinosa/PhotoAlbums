//
//  Photo.swift
//  PhotoAlbums
//
//  Created by Diego Espinosa on 10/2/19.
//  Copyright © 2019 Diego Espinosa. All rights reserved.
//

import Foundation

class Photo {
    var albumId : Int
    var id: Int
    var title: String
    var url: String
    var thumbnailUrl: String
    
    init(_ albumId: Int, _ id: Int, _ title: String, _ url: String, _ thumbnailUrl: String) {
        self.albumId = albumId
        self.id = id
        self.title = title
        self.url = url
        self.thumbnailUrl = thumbnailUrl
    }
}
