//
//  DetailViewPresentationController.swift
//  Five00px
//
//  Created by Ernesto García on 19/11/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import UIKit

class DetailViewPresentationController: UIPresentationController {
  
  struct Constants {
    
    static let BackgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.4)
    static let VerticalMargin:CGFloat = 50.0
    static let HorizontalMargin:CGFloat = 20.0
    static let CornerRadius:CGFloat = 6.0

  }
  let bkView = UIView()
  
  
  override func presentationTransitionWillBegin() {
    
    bkView.backgroundColor = Constants.BackgroundColor
    bkView.alpha = 0.0
    
    bkView.frame = containerView!.bounds
    
    containerView?.addSubview(bkView)
    
    presentedViewController.view.layer.cornerRadius = Constants.CornerRadius
    
    
    let gesture = UITapGestureRecognizer(target: self, action: "tappedInBackgroundView:")
    bkView.addGestureRecognizer(gesture)
    
    if let transitionCoordinator = presentingViewController.transitionCoordinator() {
      transitionCoordinator.animateAlongsideTransition({ (context) -> Void in
        self.bkView.alpha = 1.0
        }, completion: { (context) -> Void in
          
      })
    }
    
  }
  
  override func dismissalTransitionWillBegin() {
    presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ (context) -> Void in
      self.bkView.alpha = 0.0
      }, completion: nil)
  }
  
  override func dismissalTransitionDidEnd(completed: Bool) {
    if completed {
      self.bkView.removeFromSuperview()
    }
  }
  
  override func presentationTransitionDidEnd(completed: Bool) {
    if !completed {
      bkView.removeFromSuperview()
    }
  }
  
  override func frameOfPresentedViewInContainerView() -> CGRect {
    
    guard let frame  = containerView?.bounds else {
      return CGRectZero
    }
    return  CGRectInset(frame, Constants.HorizontalMargin, Constants.VerticalMargin)
    
  }
  
  func tappedInBackgroundView(sender:UITapGestureRecognizer ) {
    
      print("Tapped in the background view")
      self.presentingViewController.dismissViewControllerAnimated(true, completion: nil)
  }
  
}
