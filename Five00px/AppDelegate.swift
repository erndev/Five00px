//
//  AppDelegate.swift
//  Five00px
//
//  Created by Ernesto García on 18/11/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  

  
  private struct Constants {
    static let StoreFileName = "cdstore.dat"
    static let SortField = "rating"
  }
  
  var window: UIWindow?
  var store:CoreDataStore!

  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    guard buildCoreDataStore() else {
      print("Error intializing core data store")
      return false
    }
    setupRootViewController()
    return true
  }
  
}


//MARK: - Initial setup
extension AppDelegate {
  
  
  func photosResultsController() -> NSFetchedResultsController? {
    guard let context = store.managedObjectContext else {
      return nil
    }
    let request = context.fetchRequestForEntitiesWithName(PhotoManaged.entityName, orderedBy: Constants.SortField, ascending: false, predicate: nil)
    return  NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
  }
  
  func setupRootViewController() {
    
    MainTheme().applyTheme()

    let mainVC = PhotosViewController()
    mainVC.controller = photosResultsController()
    mainVC.photosService = PhotosService(store: store, importService: PhotoImportService(store: store) )
    mainVC.imageDownloadService = ImageDownloadService()
    
    self.window = UIWindow( frame: UIScreen.mainScreen().bounds)
    self.window?.rootViewController = UINavigationController(rootViewController: mainVC )
    self.window?.makeKeyAndVisible()
    
  }
  
  
  func storeURL() -> NSURL? {
    
    let url = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
    return url?.URLByAppendingPathComponent(Constants.StoreFileName)
  }
  
  func buildCoreDataStore() -> Bool {
    guard let url = storeURL() else {
      return false
    }
    store  = CoreDataStore(storePath: url , modelURL: nil, storeType: .Sqlite)
    guard store != nil else {
      return false
    }
    return store!.setupStore()
  }
  
  
  
}

