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
//  Found solution for saving images
//  https://www.hackingwithswift.com/read/13/5/saving-to-the-ios-photo-library
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
        activityIndicator.startAnimating()
        guard let photo = selectedPhoto else {fatalError("Error setting photo")}
        self.photoImageView.loadImageFromString(urlString: photo.url) {
            self.activityIndicator.stopAnimating()
            self.photoTitle.text = "'\(photo.title)'"
        }
    }
    
    @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let alertController = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
        } else {
            let alertController = UIAlertController(title: "Saved", message: "You succesfully saved the image", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
        }
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

    @IBAction func saveImageToPhotoLibrary(_ sender: Any) {
        guard let image = photoImageView.image else {return}
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImage), nil)
    }
    
}

