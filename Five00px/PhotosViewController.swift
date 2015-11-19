//
//  PhotosViewController.swift
//  Five00px
//
//  Created by Ernesto García on 18/11/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import UIKit
import CoreData

class PhotosViewController: UIViewController {
  
  private enum Layout: Int {
    case Grid
    case List
  }
  
  struct Constants {
    static let ReuseIdentifier = "PhotoCellReuseID"
    static let NibName = "PhotoCollectionViewCell"
    static let Margins:CGFloat = 4.0
    static let GridItemHeight:CGFloat = 200.0
    static let LayoutAnimationDuration = 0.3
  }
  
  @IBOutlet weak var collectionView:UICollectionView!
  
  var photosService:PhotosServiceProtocol?
  var imageDownloadService:ImageDownloadServiceProtocol?
  var dataSource:CoreDataCollectionViewDataSource?
  var controller:NSFetchedResultsController?
  var refreshControl:UIRefreshControl!
  var segmentedControl:UISegmentedControl!
  var numberFormatter = NSNumberFormatter()
  
  var detailTransitionDelegate =  DetailTransitionDelegate()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureCollectionView()
    setupSegmentedControl()
    requestImages()
  }
  
  
  func setupSegmentedControl() {
    
    segmentedControl = UISegmentedControl(items: [ NSLocalizedString("Grid", comment: ""), NSLocalizedString("List", comment:"") ])
    segmentedControl.sizeToFit()
    navigationItem.titleView = segmentedControl
    segmentedControl.addTarget(self, action: "segmentedChanged:", forControlEvents: .ValueChanged)
    segmentedControl.selectedSegmentIndex = 0
    numberFormatter.maximumFractionDigits = 1
  }
  
  func segmentedChanged(sender:UISegmentedControl ) {
    refreshLayout()
  }
  
  private func updateLayout(layout:Layout) {
    print("Segmented changed")
    let flowLayout = UICollectionViewFlowLayout()
    if layout == .Grid {
      
      let width = view.bounds.size.width / 2.0
      flowLayout.itemSize = CGSize(width: width - 2*Constants.Margins, height: width)
      flowLayout.minimumInteritemSpacing = Constants.Margins
      flowLayout.minimumLineSpacing = Constants.Margins
      flowLayout.sectionInset = UIEdgeInsets(top: Constants.Margins, left: Constants.Margins+1, bottom: Constants.Margins, right: Constants.Margins+1)
    }
    else
    {
      let width = view.bounds.size.width
      flowLayout.itemSize = CGSize(width: width, height: Constants.GridItemHeight )
      flowLayout.minimumInteritemSpacing = Constants.Margins
      flowLayout.minimumLineSpacing = Constants.Margins
      
    }
    UIView.animateWithDuration(Constants.LayoutAnimationDuration) { () -> Void in
      self.collectionView.collectionViewLayout = flowLayout
    }

  }
  
  func configureCollectionView() {
    
    
    
    collectionView.registerNib( UINib(nibName: Constants.NibName, bundle: nil) , forCellWithReuseIdentifier: Constants.ReuseIdentifier )
    dataSource = CoreDataCollectionViewDataSource(collectionView: collectionView, controller: controller!, reuseIdentifier: Constants.ReuseIdentifier, cellConfigurator: self)
    dataSource?.reload()
    collectionView.delegate = self
    
    refreshControl = UIRefreshControl()
    refreshControl?.addTarget(self, action: "requestImages", forControlEvents: .ValueChanged)
    collectionView?.addSubview(refreshControl!)
    
  }
  
  func refreshLayout() {
    
    if let layout = Layout(rawValue: segmentedControl.selectedSegmentIndex)   {
      updateLayout( layout )
    }
    
  }
  
  override func viewWillAppear(animated: Bool) {
    refreshLayout()
  }
  
  func requestImages() {

    showProgress(true)
    photosService?.findBestRatingPictures({ (error) -> Void in
      
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.photosReceivedWithError(error)
      })
      
    })
  }
  
  func photosReceivedWithError(error:NSError? ) {
    showProgress(false)
    print("Photos received...")
    refreshControl.endRefreshing()
    if let error = error {
      showErrorMessage(error.localizedDescription)
    }
    
  }
  
  func showErrorMessage(message:String) {
    let alert = UIAlertController(title: NSLocalizedString("Error loading Images", comment: ""), message: message, preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
}

extension PhotosViewController : UICollectionViewDelegate {
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
      let detailViewController = PhotoDetailViewController()
      detailViewController.photo =  dataSource?.photoAtIndexPath(indexPath)
      detailViewController.imageDownloadService = imageDownloadService
    
      // Custom presentation
      detailViewController.modalPresentationStyle = .Custom
      detailViewController.transitioningDelegate = detailTransitionDelegate
      self.presentViewController(detailViewController, animated: true, completion: nil)
    
  }
  
  func showProgress(show:Bool) {
    
      UIApplication.sharedApplication().networkActivityIndicatorVisible = show
  }
}


extension PhotosViewController : PhotoCellConfigurationProtocol {
  
  func configureCell( cell:UICollectionViewCell, atIndexPath:NSIndexPath, withPhoto photo:Photo ) {
    
    if let photoCell = cell as? PhotoCellUpdateProtocol {
      var ratingString:String
      if  let rating = photo.rating , formattedNumber = numberFormatter.stringFromNumber(rating )  {
          ratingString = formattedNumber
      }
      else {
          ratingString = NSLocalizedString("N/A", comment: "")
      }
      
      photoCell.updateName(photo.name, rating: ratingString )
      
      imageDownloadService?.downloadImageAtURL(photo.url, completion: { (image, error) -> Void in
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            photoCell.updateImage(image )
        })
        
      })
      
    }
  }
}

