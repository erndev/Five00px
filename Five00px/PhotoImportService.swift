//
//  PhotoImportService.swift
//  Five00px
//
//  Created by Ernesto García on 18/11/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import CoreData


class PhotoImportService : PhotoImportServiceProtocol {
  
  
  
  let store:CoreDataStore
  
  
  init(store:CoreDataStore ) {
    self.store = store
  }
  
  func managedFromPhoto( photo:Photo , inContext context:NSManagedObjectContext) -> PhotoManaged? {
    
    
    let managedPhoto = context.entityWithName(PhotoManaged.entityName, andValue: photo.identifier, forKey: "identifier", createIfNotExists: true) as? PhotoManaged
    managedPhoto?.identifier = photo.identifier
    managedPhoto?.updateWithPhoto(photo)
    return managedPhoto
    
  }
  
  
  func importPhotos(photos: [Photo], completion: (error: NSError?) -> Void) {
  
    let privateContext = store.privateManagedObjectContext()
    
    privateContext.performBlock { () -> Void in
      
      for photo in photos {
        
        let managedPhoto = self.managedFromPhoto(photo, inContext: privateContext)
        if managedPhoto == nil {
          print("Error insertando la photo en el contexto: \(photo)")
        }
      }
      
      do {
        try privateContext.save()
      }
      catch let error as NSError {
        print("Error saving background context: \(error)")
        completion(error: error)
        return
      }
      
      // Save the parent contexts
      self.store.saveWithCompletionBlock({ (error) -> () in
        if let error = error  {
          print("Error saving main contexts. \(error)")
        }
        else {
          print("Main contexts saved")
        }
        completion(error: error)
      })
    }
    
  }
  
}