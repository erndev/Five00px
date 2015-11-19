//
//  PhotoCellProtocol.swift
//  Five00px
//
//  Created by Ernesto García on 19/11/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import UIKit


protocol PhotoCellUpdateProtocol {
  
  func updateImage( image:UIImage?)
  func updateName( name:String , rating:String )
  
}