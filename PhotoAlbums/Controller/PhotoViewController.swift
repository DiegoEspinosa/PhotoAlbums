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
        photoTitle.isHidden = true
        loadInPhoto()
    }
    
    
    // MARK: - Private Functions
    private func loadInPhoto() {
        activityIndicator.startAnimating()
        guard let photo = selectedPhoto else {fatalError("Error setting photo")}
        photoImageView.downloadImage(from: photo.url)
        self.photoTitle.text = "'\(photo.title)'"
        self.photoTitle.isHidden = false
        self.activityIndicator.stopAnimating()
    }
    
    @objc private func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        sender.view?.removeFromSuperview()
    }
    
    // MARK: - Actions
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
    }


}

