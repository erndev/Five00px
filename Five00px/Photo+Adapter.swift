//
//  Photo+Adapter.swift
//  Five00px
//
//  Created by Ernesto García on 18/11/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import Foundation


extension Photo {
  
  struct Fields {
    static let ID = "id"
    static let ImageURL = "image_url"
    static let Name = "name"
    static let User = "user"
    static let UserName = "username"
    static let UserFullName = "fullname"
    static let UserAvatar = "userpic_url"
    static let Rating = "rating"
    static let Description = "description"
    static let Camera = "camera"
    static let Lens = "lens"
    static let ISO = "iso"
    static let Shutter = "shutter_speed"
    static let Longitude = "longitude"
    static let Latitude = "latitude"
  }
  
  
  // MARK: - Parse Json -> Photo
  init?(json:NSDictionary) {
    
    // Check mandatory values
    guard  let identifier = json[Fields.ID] as? Int,
          urlString = json[Fields.ImageURL] as? String  ,
          name = json[Fields.Name] as? String else {
        return nil
    }
    guard let url = NSURL(string: urlString) else {
      return nil
    }
    // Check mandatory user fields
    guard let jsonUser = json[Fields.User] as? NSDictionary  else {
      return nil
    }
    
    guard let username = jsonUser[Fields.UserName] as? String  else {
      return nil
    }
    
 
    self.identifier = identifier
    self.url = url
    self.name = name
    self.rating = json[Fields.Rating] as? Float
    self.detailText = json[Fields.Description] as? String
    self.userFullName = jsonUser[Fields.UserFullName] as? String
    self.userName = username
    self.camera  = json[Fields.Camera] as? String
    self.lens  = json[Fields.Lens] as? String
    self.iso = json[Fields.ISO] as? String
    self.shutter = json[Fields.Shutter] as? String
    self.longitude = json[Fields.Longitude] as? Double
    self.latitude = json[Fields.Latitude] as? Double
    if let avatar = jsonUser[Fields.UserAvatar] as? String  {
      self.avatar = NSURL(string: avatar)
    }
    else {
      self.avatar = nil
    }
  }
  
  
  //MARK: Core Data -> Photo
  init?(managedPhoto:PhotoManaged ) {
    guard let urlString = managedPhoto.url , identifier = managedPhoto.identifier?.integerValue, name = managedPhoto.name,  url = NSURL(string: urlString) else {
      return nil
    }
    self.identifier = identifier
    self.url = url
    self.name = name
    self.rating = managedPhoto.rating?.floatValue
    self.detailText = managedPhoto.detailtext
    self.userName = managedPhoto.username
    self.userFullName  = managedPhoto.userfullname
    self.camera = managedPhoto.camera
    self.lens = managedPhoto.lens
    self.iso = managedPhoto.iso
    self.shutter = managedPhoto.shutter
    self.longitude = managedPhoto.longitude?.doubleValue
    self.latitude = managedPhoto.latitude?.doubleValue
    
    if let avatar = managedPhoto.avatar   {
      self.avatar = NSURL(string: avatar)
    }
    else {
      self.avatar = nil
    }
    
  }
  
  
  
}