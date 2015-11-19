//
//  ImageDownloadServiceProtocol.swift
//  Five00px
//
//  Created by Ernesto García on 18/11/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import UIKit

protocol ImageDownloadServiceProtocol {
  
  func downloadImageAtURL( url:NSURL , completion:( image:UIImage?, error:NSError? ) -> Void )
  func cachedImageForURL( url:NSURL) -> UIImage?
}