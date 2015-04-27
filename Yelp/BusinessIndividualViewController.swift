//
//  BusinessIndividualViewController.swift
//  Yelp
//
//  Created by Holly French on 4/27/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

protocol BusinessIndividualViewControllerDelegate : class {
    func didChangeBusiness(businessIndividualViewController: BusinessIndividualViewController, business: Business)
}

class BusinessIndividualViewController: UIViewController {

    weak var delegate: BusinessIndividualViewControllerDelegate? = nil
    
    var business: Business!

    @IBOutlet weak var businessNameLabel: UILabel!
    
    @IBOutlet weak var businessImageView: UIImageView!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var snippetTextLabel: UILabel!
    
    @IBOutlet weak var reviewCountLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var ratingImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.businessImageView.layer.cornerRadius = 3
        self.businessImageView.clipsToBounds = true
        self.businessNameLabel.text = self.business.name
        self.businessImageView.setImageWithURL(self.business.imageURL)
        self.addressLabel.text = self.business.address
        self.snippetTextLabel.text = self.business.snippet
        self.reviewCountLabel.text = "\(self.business.reviewCount!) Reviews"
        self.categoryLabel.text = self.business.categories
        self.ratingImageView.setImageWithURL(self.business.ratingImageURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
