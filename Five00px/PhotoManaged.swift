//
//  PhotoManaged.swift
//  Five00px
//
//  Created by Ernesto García on 18/11/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import Foundation
import CoreData

@objc(PhotoManaged)
class PhotoManaged: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
  static let entityName = "Photo"
  
  func updateWithPhoto( photo:Photo ) {
    
      self.identifier  = photo.identifier
      self.url = photo.url.absoluteString
      self.name = photo.name
      self.rating = photo.rating
      self.detailtext = photo.detailText
      self.username = photo.userName
      self.userfullname = photo.userFullName
      self.avatar = photo.avatar?.absoluteString
      self.camera = photo.camera
      self.lens = photo.lens
      self.iso = photo.iso
      self.shutter = photo.shutter
      self.longitude = photo.longitude
      self.latitude = photo.latitude
  }
}
