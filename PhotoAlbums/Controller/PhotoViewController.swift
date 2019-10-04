//
//  PhotoViewController.swift
//  PhotoAlbums
//
//  Created by Diego Espinosa on 10/1/19.
//  Copyright © 2019 Diego Espinosa. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    public var selectedPhoto : Photo?
    private let navTitle = "Photo"
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitle: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navItem.title = navTitle
        loadInPhoto()
    }
    
    
    // MARK: - Private Functions
    private func loadInPhoto() {
        guard let photo = selectedPhoto else {fatalError("Error setting photo")}
        
        activityIndicator.startAnimating()
        photoImageView.downloadImage(from: photo.url)
        photoTitle.text = "\(photo.title)"
        activityIndicator.stopAnimating()
    }


}

