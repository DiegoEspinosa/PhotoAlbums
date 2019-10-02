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
    private let navTitle = "Photo Albums"
    private let reuseIdentifier = "PhotoAlbumCell"
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView.register(UINib(nibName: "PhotoAlbumsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
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
        cell.albumImageView.downloadImage(from: album.albumPhotos[0].thumbnailUrl)
        cell.albumIdLabel.text = String(album.albumId)
        roundCorners(cell)
        return cell
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //perform segue
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //prepare data
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
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        activityIndicator.stopAnimating()
        //retry button in the view is to be displayed to allow user to retry (retry button will be hidden when the button is pressed
    }
    
    private func roundCorners(_ cell: PhotoAlbumsCollectionViewCell) {
        cell.albumIdLabel.layer.cornerRadius = 10
        cell.albumIdLabel.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
    }
}
