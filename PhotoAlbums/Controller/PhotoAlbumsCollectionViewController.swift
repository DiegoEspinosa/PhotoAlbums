//
//  PhotoAlbumsCollectionViewController.swift
//  PhotoAlbums
//
//  Created by Diego Espinosa on 10/2/19.
//  Copyright © 2019 Diego Espinosa. All rights reserved.
//

import UIKit

class PhotoAlbumsCollectionViewController: UICollectionViewController {
    
    private var photoAlbums : Array<Album> = []
    private let navTitle = "Albums"
    private let reuseIdentifier = "PhotoAlbumCell"
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView.register(UINib(nibName: "PhotoAlbumsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

        navItem.title = navTitle
        loadInAllAlbums()
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAlbums.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoAlbumsCollectionViewCell
        let album = photoAlbums[indexPath.row]
        cell.albumImageView.downloadImageFrom(urlString: album.albumPhotos[0].thumbnailUrl, imageMode: .scaleAspectFit)
        roundCellCorners(cell)
        return cell
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toAlbumView", sender: self.collectionView.cellForItem(at: indexPath))
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAlbumView" {
            guard let photoAlbumVC = segue.destination as? AlbumPhotosCollectionViewController else {fatalError("Error setting collection view controller")}
            guard let selectedCell = sender as? PhotoAlbumsCollectionViewCell else {fatalError("Error setting cell")}
            guard let indexPath = collectionView.indexPath(for: selectedCell) else {fatalError("Error getting indexPath")}
            photoAlbumVC.selectedAlbum = photoAlbums[indexPath.row]
        }
    }
    
    // MARK: - Private Functions
    private func loadInAllAlbums() {
        activityIndicator.startAnimating()
           PhotoAlbumSingleton.shared.fetchAllAlbums().map { albums in
            self.photoAlbums = albums
            self.collectionView.reloadData()
           }.done {
            self.activityIndicator.stopAnimating()
           }.catch { error in
            self.displayAlert()
           }
    }
    
    private func displayAlert() {
        let alert = UIAlertController(title: "Something went wrong", message: "There was a problem retrieving data. Please try again", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
            self.loadInAllAlbums()
        }
        alert.addAction(okAction)
        alert.addAction(retryAction)
        self.present(alert, animated: true, completion: nil)
        activityIndicator.stopAnimating()
    }
    
    private func roundCellCorners(_ cell: PhotoAlbumsCollectionViewCell) {
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
    }
}
