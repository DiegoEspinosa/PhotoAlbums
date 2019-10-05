//
//  PhotoViewController.swift
//  PhotoAlbums
//
//  Created by Diego Espinosa on 10/1/19.
//  Copyright © 2019 Diego Espinosa. All rights reserved.
//
//  Found solution for imageTapped on Stackoverflow:
//  https://stackoverflow.com/questions/34694377/swift-how-can-i-make-an-image-full-screen-when-clicked-and-then-original-size
//

import UIKit

class PhotoViewController: UIViewController {
    
    public var selectedPhoto : Photo?
    private let navTitle = "Photo"
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var photoImageView: CustomImageView!
    @IBOutlet weak var photoTitle: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navItem.title = navTitle
        loadInPhoto()
    }
    
    
    // MARK: - Private Functions
    private func loadInPhoto() {
        guard let photo = selectedPhoto else {fatalError("Error setting photo")}
        photoImageView.downloadImageFrom(urlString: photo.url, imageMode: .scaleAspectFit)
        self.photoTitle.text = "'\(photo.title)'"
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

