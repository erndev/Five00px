//
//  PhotoDetailViewController.swift
//  Five00px
//
//  Created by Ernesto García on 19/11/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import UIKit
import MapKit

class PhotoDetailViewController: UIViewController {

  
  struct Constants {
    
    static let MapRegionDistance:CLLocationDistance = 1000000
    static let NotAvailableText = NSLocalizedString("N/A", comment: "")
  }
  
  
  @IBOutlet weak var imageView:UIImageView!
  @IBOutlet weak var avatarImageView:UIImageView!
  @IBOutlet weak var photoNameLabel:UILabel!
  @IBOutlet weak var nameLabel:UILabel!
  @IBOutlet weak var fullNameLabel:UILabel!
  @IBOutlet weak var descriptionLabel:UILabel!
  @IBOutlet weak var cameraLabel:UILabel!
  @IBOutlet weak var lensLabel:UILabel!
  @IBOutlet weak var isoLabel:UILabel!
  @IBOutlet weak var shutterLabel:UILabel!
  @IBOutlet weak var mapView:MKMapView!
  
  
    var photo:Photo?
    var imageDownloadService:ImageDownloadServiceProtocol?
  
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        configureUI()
        updateViewInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  
  func configureUI() {
      avatarImageView.layer.borderColor = UIColor.grayColor().CGColor
      avatarImageView.layer.borderWidth = 2.0
      avatarImageView.layer.cornerRadius = avatarImageView.bounds.width/2.0
      avatarImageView.clipsToBounds = true
  }
  
  func updateViewInfo() {
    
    showPhotoInfo()
    showUserInfo()
    showCameraInfo()
    showImageLocation()
    
  }
  
  func showPhotoInfo() {
    photoNameLabel.text = photo?.name
    showImageFromURL(photo?.url, inImageView: imageView, placeHolder: UIImage(named: "noimage"))

    descriptionLabel.text = photo?.detailText ?? ""
    
  }
  
  func showUserInfo() {
    // User info
    nameLabel.text = photo?.userName ?? Constants.NotAvailableText
    fullNameLabel.text = photo?.userFullName ?? Constants.NotAvailableText
    showImageFromURL(photo?.avatar, inImageView: avatarImageView, placeHolder:UIImage(named: "profile"))
    
  }
  
  func showCameraInfo() {
    
    // Camera info

    guard photo?.camera != nil  ||  photo?.lens != nil ||  photo?.iso != nil ||  photo?.shutter != nil else  {
      return
    }
    
    cameraLabel.text = photo?.camera ?? Constants.NotAvailableText
    lensLabel.text = photo?.lens ?? Constants.NotAvailableText
    isoLabel.text = photo?.iso ?? Constants.NotAvailableText
    shutterLabel.text = photo?.shutter ?? Constants.NotAvailableText
  }

  func showImageLocation( ) {
    // Hide the map if the photo does not have any information
    guard let latitude  = photo?.latitude , longitude = photo?.longitude else {
      mapView.hidden  = true
      return
    }
    
    let annotation = MKPointAnnotation()
    annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    mapView.addAnnotation(annotation)
    let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, Constants.MapRegionDistance, Constants.MapRegionDistance)
    mapView.setRegion(region, animated: false)
  }
  
  func showImageFromURL( url:NSURL?,  inImageView imageView:UIImageView , placeHolder:UIImage? ){
    
    imageView.image  = placeHolder
    guard let url = url else {
      mapView.hidden = true
      return
    }
    imageDownloadService?.downloadImageAtURL(url, completion: { (image, error) -> Void in
      
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
          imageView.image = image
      })
    })
  }
  
  
}
