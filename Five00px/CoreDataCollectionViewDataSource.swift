//
//  CoreDataCollectionViewDataSource.swift
//  Five00px
//
//  Created by Ernesto García on 18/11/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import CoreData
import UIKit

private struct Change {
  let type:NSFetchedResultsChangeType
  let indexPath:NSIndexPath?
  let newIndexPath:NSIndexPath?
  
  init( type:NSFetchedResultsChangeType, indexPath:NSIndexPath?, newIndexPath:NSIndexPath?) {
    self.type = type
    self.indexPath = indexPath
    self.newIndexPath = newIndexPath
  }
}


class CoreDataCollectionViewDataSource : NSObject {
  
  
  private var objectChanges = [Change]()
  private var sectionChanges = [Change]()
  
  let collectionView:UICollectionView
  let reuseIdentifier:String?
  let cellConfigurator:PhotoCellConfigurationProtocol
  let controller :NSFetchedResultsController

  
  init( collectionView:UICollectionView,  controller:NSFetchedResultsController,  reuseIdentifier:String , cellConfigurator:PhotoCellConfigurationProtocol ) {
    
    self.controller = controller
    self.reuseIdentifier  = reuseIdentifier
    self.collectionView = collectionView
    self.cellConfigurator = cellConfigurator
    
    super.init()
    
    self.collectionView.dataSource = self
    self.controller.delegate = self
  }
  
  func photoAtIndexPath(indexPath:NSIndexPath) -> Photo? {
    
    if let managedPhoto = controller.objectAtIndexPath(indexPath) as? PhotoManaged {
      return Photo(managedPhoto: managedPhoto)
    }
    return nil
  }
  
  func reload() {
    
    do {
      try controller.performFetch()
    }
    catch let error as NSError {
      print("Error fetching : \(error)")
    }
  }
}


extension CoreDataCollectionViewDataSource : UICollectionViewDataSource {
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let section = controller.sections?[section] {
      return section.numberOfObjects
    }
    return 0
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    
    return controller.sections?.count ?? 0
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier!, forIndexPath: indexPath)
    if let photo = self.photoAtIndexPath(indexPath ) {
      cellConfigurator.configureCell(cell, atIndexPath: indexPath, withPhoto: photo)
    }
    return cell
  }
  
  
}

extension CoreDataCollectionViewDataSource: NSFetchedResultsControllerDelegate {
  
  func controllerWillChangeContent(controller: NSFetchedResultsController) {
    
    sectionChanges.removeAll()
    objectChanges.removeAll()
  }
  
  func controllerDidChangeContent(controller: NSFetchedResultsController) {
    collectionView.performBatchUpdates({ () -> Void in
      self.applySectionChanges()
      self.applyRowChanges()
      }, completion: { (ret) -> Void in
        self.sectionChanges.removeAll()
        self.objectChanges.removeAll()
    })
    
    
  }
  
  
  func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
    
    objectChanges.append(Change(type: type, indexPath: indexPath, newIndexPath: newIndexPath))
  }
  
  func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
    sectionChanges.append(Change(type: type, indexPath: NSIndexPath(forRow: 0, inSection: sectionIndex), newIndexPath: nil))
    
  }
  
  func applySectionChanges() {
    
    for change in sectionChanges {
      
      guard let sectionIndex = change.indexPath?.section else {
        continue
      }
      
      let sectionIndexSet = NSIndexSet(index: sectionIndex)
      
      switch change.type {
      case .Insert:
        collectionView.insertSections(sectionIndexSet)
      case .Delete:
        collectionView.deleteSections(sectionIndexSet)
      case .Update:
        collectionView.reloadSections(sectionIndexSet)
      case .Move:
        break
      }
    }
  }
  
  func applyRowChanges() {
    for change in objectChanges {
      
      switch change.type {
      case .Delete:
        collectionView.deleteItemsAtIndexPaths([change.indexPath!])
      case .Insert:
        collectionView.insertItemsAtIndexPaths([change.newIndexPath!])
      case .Move:
        collectionView.moveItemAtIndexPath(change.indexPath!, toIndexPath: change.newIndexPath!)
      case .Update:
        collectionView.reloadItemsAtIndexPaths([change.indexPath!])
      }
    }
    
  }
  
}
