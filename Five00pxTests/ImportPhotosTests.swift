//
//  ImportPhotosTests.swift
//  Five00px
//
//  Created by Ernesto García on 18/11/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import XCTest
@testable import Five00px



class ImportPhotosTests: XCTestCase {
  var store:CoreDataStore!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
      
      store = CoreDataStore(storePath: nil, modelURL: nil, storeType: .InMemory)
      let ret = store.setupStore()
      XCTAssertTrue(ret, "Error initializing the store")

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

  func testImport() {
    
    let expectation = expectationWithDescription("import-expectaction")
    
    guard let jsonResponse = readJsonFile("photosresult1.txt", bundle: NSBundle(forClass: self.dynamicType)) as? NSDictionary , jsonPhotos = jsonResponse["photos"] as? [NSDictionary] else {
      XCTFail("Error reading json file with photos")
      return
    }
    
    let photos = jsonPhotos.map {
      return Photo(json: $0)!
      }.filter{
        $0 != nil }
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
     
        let importer = PhotoImportService(store: self.store)
      
        importer.importPhotos(photos) { error in
            print("\(error)")
          expectation.fulfill()
          }
      
      
    }
    
    waitForExpectationsWithTimeout(5.0) { (error) -> Void in
      
      print("\(error)")
      let allEntities = self.store.managedObjectContext?.allEntitiesWithName(PhotoManaged.entityName)
      
      XCTAssertTrue(photos.count ==  allEntities?.count, "Not all the photos are in the main context")
      
      let entity = self.store.managedObjectContext?.entityWithName(PhotoManaged.entityName, andValue: photos.first!.identifier, forKey: "identifier") as? PhotoManaged
      XCTAssertEqual(entity?.identifier, photos.first!.identifier, "Not the same photo...")
      
    }

  }
}
