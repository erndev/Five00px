//
//  FiveHundredPxAPI.swift
//  Five00px
//
//  Created by Ernesto García on 18/11/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import Foundation

class FiveHundredPxAPI {
  
  enum EndPoint : String {
    case Photos = "photos"
  }
  
  private struct ApiConstants {
    static let ConsumerKeyParamName = "consumer_key"
    static let ConsumerKeyValue = "hGdTjtRc1YPlnRzzjnfLyYNENBqhJUhQTzELlbTp"  // this should be a param  in the init
    static let ApiProtocol = "https"
    static let ApiHost = "api.500px.com"
    static let ApiVersion = "v1"
  }
  
  private struct PhotosConstants {
    static let PhotosFieldName = "photos"
    static let FeatureParamName = "feature"
    static let PopularParamValue = "popular"
    static let SortParamName = "sort"
    static let SortParamValue = "rating"
    static let ImageSizeParamName = "image_size"
    static let ImageSizeParamValue = "3"
  }
  
  let session:NSURLSession
  
  init ( ) {
    
    self.session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
  }
  
  
  func bestRatingPhotosWithCompletion( completion:(photos:[Photo]?, error:NSError? )->()  )  {
    
    let params = [PhotosConstants.FeatureParamName:PhotosConstants.PopularParamValue , PhotosConstants.SortParamName:PhotosConstants.SortParamValue, PhotosConstants.ImageSizeParamName:PhotosConstants.ImageSizeParamValue]
    
    jsonWithEndpoint(EndPoint.Photos, params: params ) { (json, error) -> () in
      
      guard let jsonDictionary = json as? NSDictionary else {
        completion( photos: nil, error: error)
        return
      }
      
      guard let photosArray = jsonDictionary[PhotosConstants.PhotosFieldName] as? [NSDictionary] where photosArray.count > 0 else {
        completion( photos: nil, error: error)
        return
      }
      
      var parsedPhotos = [Photo]()
      for photoDictionary in photosArray  {
        if let photo = Photo(json: photoDictionary) {
          parsedPhotos.append(photo)
        }
        
      }
      completion(photos: parsedPhotos, error: nil)
    }
    
  }
  
  func jsonWithEndpoint( endpoint:EndPoint, params:[String:String]?, completion:( json:AnyObject?, error:NSError?)->() )   {
    
    let urlRequest = urlRequestWithEndpoint(endpoint, params: params)
    let dataTask = session.dataTaskWithRequest(urlRequest) { (data, response, error) -> Void in
      
      guard error == nil && data?.length > 0  else {
        completion(json: nil, error: error )
        return
      }
      
      do {
        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
        completion(json: json, error: nil)
      }
      catch let jsonError as NSError {
        completion(json: nil, error: jsonError)
        return
      }
      
    }
    dataTask.resume()
  }
  
  private func urlRequestWithEndpoint( endpoint:EndPoint, params:[String:String]? ) -> NSURLRequest {
    
    
    var queryItems = [ NSURLQueryItem(name: ApiConstants.ConsumerKeyParamName, value: ApiConstants.ConsumerKeyValue)]
    if let params = params {
      for (key,value) in params {
        queryItems.append(NSURLQueryItem(name: key, value: value))
      }
    }
    var path = NSString(string: "/")
    path = path.stringByAppendingPathComponent(ApiConstants.ApiVersion)
    path = path.stringByAppendingPathComponent(endpoint.rawValue)
    
    let components = NSURLComponents()
    components.host = ApiConstants.ApiHost
    components.queryItems = queryItems
    components.path = path as String
    components.scheme = ApiConstants.ApiProtocol
    
    return NSURLRequest(URL: components.URL!)
  }

  
  
}