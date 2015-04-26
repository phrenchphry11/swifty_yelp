//
//  BusinessCell.swift
//  Yelp
//
//  Created by Holly French on 4/24/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var ratingImageView: UIImageView!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width
        self.thumbImageView.layer.cornerRadius = 3
        self.thumbImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setBusiness(business: Business) {
        self.thumbImageView.setImageWithURL(business.imageURL)
        self.nameLabel.text = business.name
        self.ratingImageView.setImageWithURL(business.ratingImageURL)
        self.ratingLabel.text = "\(business.reviewCount!) Reviews"
        self.addressLabel.text = business.address
        self.distanceLabel.text = String(format: "%.2f mi", business.distance!)
        self.categoryLabel.text = business.categories
    }
    
}
