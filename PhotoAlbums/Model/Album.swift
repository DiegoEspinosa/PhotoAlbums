//
//  Album.swift
//  PhotoAlbums
//
//  Created by Diego Espinosa on 10/2/19.
//  Copyright © 2019 Diego Espinosa. All rights reserved.
//

import Foundation

class Album {
    var albumId : Int
    var albumPhotos : Array<Photo> = []
    
    init(albumId: Int) {
        self.albumId = albumId
    }
}
