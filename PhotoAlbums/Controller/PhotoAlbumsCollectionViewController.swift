//
//  PhotoAlbumsCollectionViewController.swift
//  PhotoAlbums
//
//  Created by Diego Espinosa on 10/2/19.
//  Copyright © 2019 Diego Espinosa. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PhotoAlbumsCollectionViewController: UICollectionViewController {
    
    private var photoAlbums : Array<Album> = []
    private let navTitle = "Photo Albums"
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        navItem.title = navTitle
        loadInAllAlbums()
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
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
            print("error: \(error)")
            //future implementation of alert
           }
       }
}
