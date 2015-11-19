//
//  DetailTransitionDelegate.swift
//  Five00px
//
//  Created by Ernesto García on 19/11/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import UIKit

class DetailTransitionDelegate: NSObject , UIViewControllerTransitioningDelegate {

  func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
    
      return DetailViewPresentationController(presentedViewController: presented, presentingViewController: presenting )
  }
  
}
