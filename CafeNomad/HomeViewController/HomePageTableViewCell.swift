//
//  HomePageTableViewCell.swift
//  CafeNomad
//
//  Created by Albert on 2018/11/1.
//  Copyright © 2018 Albert.C. All rights reserved.
//

import UIKit

class HomePageTableViewCell: UITableViewCell {

    @IBOutlet var shopNameLabel: UILabel!
    @IBOutlet var shopAddressLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
