//
//  CellUpdaterProtocol.swift
//  Five00px
//
//  Created by Ernesto García on 18/11/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import UIKit

protocol PhotoCellConfigurationProtocol {
  
  func configureCell( cell:UICollectionViewCell, atIndexPath:NSIndexPath, withPhoto photo:Photo )
  
}