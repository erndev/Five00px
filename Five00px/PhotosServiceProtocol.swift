//
//  PhotosServiceProtocol.swift
//  Five00px
//
//  Created by Ernesto García on 18/11/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import UIKit

protocol PhotosServiceProtocol {
  
  func findBestRatingPictures( completion:(error:NSError? )-> Void )
  func imageForURL(imageURL:NSURL, completion: (image:UIImage?, error:NSError?)->Void )
}