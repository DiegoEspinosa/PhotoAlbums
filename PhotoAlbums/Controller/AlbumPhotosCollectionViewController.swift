//
//  AlbumPhotosCollectionViewController.swift
//  PhotoAlbums
//
//  Created by Diego Espinosa on 10/2/19.
//  Copyright © 2019 Diego Espinosa. All rights reserved.
//

import UIKit

class AlbumPhotosCollectionViewController: UICollectionViewController {
    
    public var selectedAlbum : Album?
    private let reuseIdentifier = "AlbumPhotoCell"
    private let navTitle = "Photo Album"
    
    private var photosArray : Array<Photo> = []

    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView.register(UINib(nibName: "AlbumPhotosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        navItem.title = navTitle
        loadInAlbumPhotos()
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AlbumPhotosCollectionViewCell
    
        cell.photoImageView.downloadImage(from: photosArray[indexPath.row].thumbnailUrl)
        roundCorners(cell)
        return cell
    }

    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //perform segue
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //segue prep
    }
    
    // MARK: - Private Functions
    private func loadInAlbumPhotos() {
        activityIndicator.startAnimating()
        if let passedInAlbum = selectedAlbum  {
            photosArray = passedInAlbum.albumPhotos
            collectionView.reloadData()
        }
        activityIndicator.stopAnimating()
    }
    
    private func roundCorners(_ cell: AlbumPhotosCollectionViewCell) {
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
    }

}
