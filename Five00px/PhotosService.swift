//
//  PhotosService.swift
//  Five00px
//
//  Created by Ernesto García on 18/11/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import UIKit

class  PhotosService : PhotosServiceProtocol {
  
  let store:CoreDataStore
  let api:FiveHundredPxAPI = FiveHundredPxAPI()
  var importService:PhotoImportServiceProtocol
  
  init( store:CoreDataStore, importService:PhotoImportServiceProtocol ) {
    self.store = store
    self.importService = importService
  }
  
  func findBestRatingPictures( completion:(error:NSError? )-> Void ) {
    
    api.bestRatingPhotosWithCompletion { (photos, error) -> () in
      print("Photos received..")
      guard error == nil else {
        completion(error: error)
        return
      }
      if let photos = photos {
        self.importService.importPhotos(photos){(importError) -> Void in
          completion(error: importError)
        }
      }
      
    }
  }
  
  func imageForURL(imageURL: NSURL, completion: (image: UIImage?, error: NSError?) -> Void) {
    
  }

}