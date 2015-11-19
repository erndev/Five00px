//
//  PhotoJsonTests.swift
//  Five00px
//
//  Created by Ernesto García on 18/11/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import XCTest
@testable import Five00px

func readJsonFile(filename:NSString , bundle:NSBundle) -> AnyObject? {
  
  let name = filename.stringByDeletingPathExtension
  let pathExtension = filename.pathExtension
  
  guard let url = bundle.URLForResource(   name , withExtension: pathExtension) else {
    return nil
  }
  guard let data = NSData(contentsOfURL: url) else {
    return nil
  }
  
  do {
     let json  = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
    return json
  }
  catch {
    return nil
  }

}


class PhotoJsonTests: XCTestCase {
  
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

  
  func testPhotoJson() {
      let bundle = NSBundle(forClass: self.dynamicType)
    guard  let json = readJsonFile( "photojson.txt", bundle: bundle) as? NSDictionary else {
        XCTFail("Error reading json file")
      return
    }
    
    guard let photo = Photo(json: json) else {
      XCTFail("Error parsing Photo from jsong file")
      return
    }
      XCTAssertEqual(photo.identifier, Int( 129236759))
      XCTAssertEqual(photo.url, NSURL(string: "https://drscdn.500px.org/photo/129236759/w%3D280_h%3D280/6cec3e6d97b8ec2e036604b5d9330fc9?v=3"))
      XCTAssertEqual(photo.name, "that road")
      XCTAssertEqual(photo.detailText, "misty morning in hallstatt...\n\ncontact for prints: roblfc1892@gmail.com All images are © copyright roblfc1892 - roberto pavic. You may NOT use, replicate, manipulate, or modify this image. roblfc1892 - roberto pavic © All Rights Reserved")
      XCTAssertEqual(photo.rating,Float(84.5))
    XCTAssertEqual(photo.userName, "VirginiaMaria")
    XCTAssertEqual(photo.userFullName, "Virginia Maria")
    XCTAssertEqual(photo.avatar, NSURL(string: "https://pacdn.500px.org/747838/684e99f6426ba8614709335290febcb55df87bbd/1.jpg?32"))
    XCTAssertEqual( photo.camera, "Nikon")
    XCTAssertEqual( photo.lens, "11.0-16.0 mm f/2.8")
    XCTAssertEqual( photo.iso, "100")
    XCTAssertEqual( photo.shutter, "60")
  
    XCTAssertEqual(photo.longitude, Double(23.675537109375))
    XCTAssertEqual(photo.latitude, Double(45.3004900833267))

  }

}
