//
//  MoreTableViewCell.swift
//  CafeNomad
//
//  Created by Albert on 2018/10/25.
//  Copyright © 2018 Albert.C. All rights reserved.
//

import UIKit

class MoreTableViewCell: UITableViewCell {

    @IBOutlet var myImage: UIImageView! {
        didSet {
            myImage.layer.cornerRadius = myImage.bounds.width / 2
            myImage.clipsToBounds = true
        }
    }
    @IBOutlet var myLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
