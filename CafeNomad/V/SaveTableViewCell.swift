//
//  SaveTableViewCell.swift
//  CafeNomad
//
//  Created by Albert on 2018/11/15.
//  Copyright © 2018 Albert.C. All rights reserved.
//

import UIKit

class SaveTableViewCell: UITableViewCell {

    
    @IBOutlet var shopName: UILabel!
    @IBOutlet var shopAddress: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
