//
//  MainTheme.swift
//  Five00px
//
//  Created by Ernesto García on 19/11/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import UIKit

struct MainTheme {
  
  
  func applyTheme() {
    
      UINavigationBar.appearance().barStyle = .Black
      UISegmentedControl.appearanceWhenContainedInInstancesOfClasses([UINavigationBar.self]).tintColor = UIColor(hue: 0/360, saturation: 0/100, brightness: 96.9/100, alpha: 1.0)
  }
}