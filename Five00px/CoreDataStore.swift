//
//  CoreDataStore.swift
//
//  Created by Ernesto García on 17/04/15.
//  Copyright © 2015 erndev. All rights reserved.
//

import CoreData

public enum StoreType {
  case InMemory
  case Sqlite
  case Binary
  
  func toString() -> String {
    
    switch self {
    case .Sqlite:
      return NSSQLiteStoreType
    case .Binary:
      return NSBinaryStoreType
    case .InMemory:
      return NSInMemoryStoreType
    }
  }
}


public class CoreDataStore: NSObject {
  
  public private(set)     var managedObjectContext:NSManagedObjectContext?
  private                 var saveManagedObjectContext:NSManagedObjectContext?
  
  private let storePath:NSURL?
  private let modelURL:NSURL?
  private let storeType:StoreType
  
  public init(storePath:NSURL?, modelURL:NSURL? , storeType:StoreType ) {
    
    self.storePath = storePath
    self.modelURL = modelURL
    self.storeType = storeType
    
    super.init()
  }
  
  public func setupStore() -> Bool
  {
    if( managedObjectContext != nil || saveManagedObjectContext != nil ) {
      return false;
    }
    if( storePath == nil && storeType != .InMemory )
    {
      return false;
    }
    
    let model:NSManagedObjectModel?
    
    if let modelURL = modelURL  {
      model = NSManagedObjectModel(contentsOfURL: modelURL)
    }
    else {
      model = NSManagedObjectModel.mergedModelFromBundles(nil)
    }
    
    if(  model == nil )
    {
      return false
    }
    
    let psc = NSPersistentStoreCoordinator(managedObjectModel:model!)
    
    self.saveManagedObjectContext   = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    self.managedObjectContext       = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    
    if( self.saveManagedObjectContext == nil || self.managedObjectContext == nil ) {
      return false
    }
    
    self.saveManagedObjectContext?.persistentStoreCoordinator = psc
    self.managedObjectContext?.parentContext = self.saveManagedObjectContext
    
    if( storeType != .InMemory ) {
      
      makeSurePathExists(storePath)
    }
    
    let options = defaultOptionsForType(storeType)
    
    
    do {
      try psc.addPersistentStoreWithType(storeType.toString(), configuration: nil, URL: storePath, options: options)
    }
    catch {
      return false
    }
    
    return true;
  }
  
  private func defaultOptionsForType(storeStype:StoreType) -> [NSObject:AnyObject]? {
    
    if( storeStype == .InMemory) {
      return nil;
    }
    return [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
    
  }
  
  private func makeSurePathExists(path:NSURL? ) {
    if  let url  = path  {
      
      if let folder = url.URLByDeletingLastPathComponent {
        do {
          try NSFileManager.defaultManager().createDirectoryAtURL(folder, withIntermediateDirectories: true, attributes: nil)
        } catch _ {
        }
      }
      
    }
  }
  
  public func saveWithCompletionBlock( completion: ((error:NSError?)->())? )  {
    
    // Make sure this is called from the main thread
    if( !NSThread.isMainThread()) {
      
      dispatch_async(dispatch_get_main_queue() ) {
        self.saveWithCompletionBlock(completion)
      }
      return;
    }
    
    if( saveManagedObjectContext == nil || managedObjectContext == nil ) {
      completion?(error:nil)
      return
    }
    
    let saveMOC = saveManagedObjectContext!
    let mainMOC = managedObjectContext!
    
    if( !saveMOC.hasChanges && !mainMOC.hasChanges  ) {
      completion?(error:nil)
      return
    }
    
    // 1. main MOC
    do {
      try mainMOC.save()
    }
    catch let error as NSError {
      completion?(error: error )
      return
    }
    
    // 2. save parent MOC
    saveMOC.performBlock { () -> Void in
      
      do {
        try saveMOC.save()
        completion?(error:nil)
      }
      catch let error as NSError {
        completion?(error:error)
        return
      }
    }
    
  }
  
  // MARK: - Class Helpers
  public class func inMemoryStoreWithModel(modelURL:NSURL ) -> CoreDataStore
  {
    return CoreDataStore(storePath:nil, modelURL:modelURL, storeType:.InMemory)
  }
  
  public class func sqliteStoreWithPath(path:NSURL, modelURL:NSURL ) -> CoreDataStore
  {
    return CoreDataStore(storePath:path, modelURL:modelURL, storeType:.Sqlite)
  }
  
  public func privateManagedObjectContext() -> NSManagedObjectContext {
    
    let privateMOC = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType )
    privateMOC.parentContext = managedObjectContext
    return privateMOC
  }
  
}
