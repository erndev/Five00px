//
//  ImageDownloadService.swift
//  Five00px
//
//  Created by Ernesto García on 19/11/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import UIKit

// !!!!This is incomplete!!!. It should support cancellation, cache purging after a period of time, persistence...
// just for the demo

class ImageDownloadService : ImageDownloadServiceProtocol  {
  
  let cache:NSCache
  let session:NSURLSession
  
  init ( ) {
    
      cache = NSCache()
      session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
  }
  
  func cachedImageForURL( url:NSURL) -> UIImage?
  {
    return cache.objectForKey(url) as? UIImage
  }

  
  
  func downloadImageAtURL(url: NSURL, completion: (image: UIImage?, error: NSError?) -> Void) {
    
    // Find the image in the cache before trying to download
    if let image = cachedImageForURL(url) {
      completion(image: image, error: nil)
      return
    }
    
    let request = NSURLRequest(URL: url)
    let downloadSession = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
      
      guard let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200 , let data = data  else {
        completion(image: nil, error: error)
        return
      }
      let image = UIImage(data: data)
      completion(image: image, error: nil)
      if image != nil {
          self.cache.setObject(image!, forKey: url)
      }
    }
    downloadSession.resume()
  }
}