//
//  PhotoManaged+CoreDataProperties.swift
//  Five00px
//
//  Created by Ernesto García on 18/11/15.
//  Copyright © 2015 ernesto. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PhotoManaged {

    @NSManaged var identifier: NSNumber?
    @NSManaged var url: String?
    @NSManaged var name: String?
    @NSManaged var rating: NSNumber?
    @NSManaged var detailtext: String?
    @NSManaged var username: String?
    @NSManaged var userfullname: String?
    @NSManaged var avatar: String?
    @NSManaged var camera: String?
    @NSManaged var iso: String?
    @NSManaged var lens: String?
    @NSManaged var shutter: String?
    @NSManaged var longitude: NSNumber?
    @NSManaged var latitude: NSNumber?

}
