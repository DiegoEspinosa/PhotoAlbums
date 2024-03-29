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
    private let navTitle = "Photo Album"
    private let reuseIdentifier = "AlbumPhotoCell"
    private let dispatchGroup = DispatchGroup()
    
    private var photosArray : Array<Photo> = []

    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView.register(UINib(nibName: "AlbumPhotosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

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
        let photo = photosArray[indexPath.row]
        cell.photoImageView.loadImageFromString(urlString: photo.thumbnailUrl)
        
        //round cell corners
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
    }

    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toPhoto", sender: self.collectionView.cellForItem(at: indexPath))
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhoto" {
            guard let photoAlbumVC = segue.destination as? PhotoViewController else {fatalError("Error setting collection view controller")}
            guard let selectedCell = sender as? AlbumPhotosCollectionViewCell else {fatalError("Error setting cell")}
            guard let indexPath = collectionView.indexPath(for: selectedCell) else {fatalError("Error getting indexPath")}
            photoAlbumVC.selectedPhoto = photosArray[indexPath.row]
        }
    }
    
    // MARK: - Private Functions
    private func loadInAlbumPhotos() {
        if let passedInAlbum = selectedAlbum {
            activityIndicator.startAnimating()
            dispatchGroup.enter()
            DispatchQueue.main.async {
                self.photosArray = passedInAlbum.albumPhotos
                self.collectionView.reloadData()
                self.dispatchGroup.leave()
            }
            dispatchGroup.notify(queue: .main, execute: {
                self.activityIndicator.stopAnimating()
            })
        }
    }
}
