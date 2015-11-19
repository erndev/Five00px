//
//  NSManagedObjectContext+Utils.swift
//  Five00px
//
//  Created by Ernesto García on 18/11/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import CoreData


extension NSManagedObjectContext {
  
  func addEntityWithName( name:String ) -> NSManagedObject {
    
    return NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: self)
  }
  
  func fetchRequestForEntitiesWithName( name:String,  orderedBy order:String? = nil, ascending:Bool=true , predicate:NSPredicate?=nil ) -> NSFetchRequest {
    
    let request = NSFetchRequest(entityName: name)
    request.predicate = predicate
    if let order = order {
      request.sortDescriptors = [NSSortDescriptor(key: order, ascending: ascending)]
      
    }
    return request
  }
  
  func fetchRequestForEntityWithName( name:String , andValue value:AnyObject , forKey key:String )  -> NSFetchRequest {
    
    
    let request = fetchRequestForEntitiesWithName(name)
    request.fetchLimit  = 1
    if let value = value as? NSObject {
      let predicate = NSPredicate(format: "%K == %@", key, value )
      request.predicate = predicate
    }
    return request
  }
  
  func allEntitiesWithName( name:String,  orderedBy order:String?=nil, ascending:Bool=true ) -> [NSManagedObject]? {
    
    let request = fetchRequestForEntitiesWithName(name, orderedBy: order, ascending: ascending)
    do {
      let entities = try self.executeFetchRequest(request) as? [NSManagedObject]
      return entities
    }
    catch {
      return nil
    }
  }
  
  func entityWithName( name:String, andValue value:AnyObject, forKey key:String , createIfNotExists:Bool = false ) -> NSManagedObject?
  {
    let request = fetchRequestForEntityWithName(name, andValue: value, forKey: key)
    do {
      let entities = try self.executeFetchRequest(request) as? [NSManagedObject]
      if entities?.count == 0 && createIfNotExists {
        let entity = addEntityWithName(name)
        return entity
        
      }
      else {
        return entities?.first
      }
      
    }
    catch {
      return nil
    }
  }
  
}