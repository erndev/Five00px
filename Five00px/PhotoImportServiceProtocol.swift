//
//  PhotoImportServiceProtocol.swift
//  Five00px
//
//  Created by Ernesto García on 18/11/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import Foundation

protocol PhotoImportServiceProtocol {
  
  func importPhotos( photos:[Photo],  completion:(error:NSError?)-> Void )

}