//
//  Photo.swift
//  Five00px
//
//  Created by Ernesto García on 18/11/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import Foundation

struct Photo {
  
  let identifier:Int
  let url:NSURL
  let name:String
  let rating:Float?
  let detailText:String?
  let userName:String?
  let userFullName:String?
  let avatar:NSURL?
  let camera:String?
  let lens:String?
  let iso:String?
  let shutter:String?
  let longitude:Double?
  let latitude:Double?
  
  
  init( identifier:Int, url:NSURL, name:String, userName:String,  userFullName:String?, rating:Float?, detailText:String?, avatar:NSURL?, camera:String?, longitude:Double?, latitude:Double, lens:String? , shutter:String?, iso:String?) {
    
    self.identifier = identifier
    self.url =  url
    self.name  = name
    self.rating = rating
    self.detailText  = detailText
    self.userFullName = userFullName
    self.userName = userName
    self.avatar = avatar
    self.camera   = camera
    self.lens = lens
    self.shutter = shutter
    self.iso = iso
    self.longitude = longitude
    self.latitude = latitude
  }
}