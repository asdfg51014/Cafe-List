//
//  WalkthroughContentViewController.swift
//  CafeNomad
//
//  Created by Albert on 2018/11/27.
//  Copyright © 2018 Albert.C. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController  {
    
    

    var index = 0
    
    var heading = ""
    
    var subHeading = ""
    
    var imageFile = ""
    
    @IBOutlet var contentImage: UIImageView!
    
    @IBOutlet var headingLabel: UILabel! {
        didSet {
            headingLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var subheadingLabel: UILabel! {
        didSet {
            subheadingLabel.numberOfLines = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headingLabel.text = heading
        subheadingLabel.text = subHeading
        contentImage.image = UIImage(named: imageFile)
        
    }
    
}
