//
//  PhotoCollectionViewCell.swift
//  Five00px
//
//  Created by Ernesto García on 18/11/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var imageView:UIImageView!
  @IBOutlet weak var nameLabel:UILabel!
  @IBOutlet weak var ratingLabel:UILabel!
  @IBOutlet weak var ratingContainerView:UIView!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    ratingContainerView.layer.cornerRadius = 6.0
    ratingContainerView.clipsToBounds = true
  }
  
  override func prepareForReuse() {
      self.imageView.image = nil
      self.imageView.hidden = true

  }
  
}


extension PhotoCollectionViewCell: PhotoCellUpdateProtocol {
  
  func updateImage(image: UIImage?) {
      self.imageView.image = image
      UIView.animateWithDuration(0.4) { () -> Void in
        self.imageView.hidden = false
    }
  }
  
  func updateName(name: String, rating: String) {
  
      self.nameLabel.text = name
      self.ratingLabel.text = rating
  }
  
}

