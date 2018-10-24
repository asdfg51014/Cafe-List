//
//  DetailViewController.swift
//  CafeNomad
//
//  Created by Albert on 2018/10/23.
//  Copyright © 2018 Albert.C. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var detail: [CafeAPI] = []
    
    var number: Int?
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var wifiLabel: UILabel!
    @IBOutlet var seatLabel: UILabel!
    @IBOutlet var tastyLabel: UILabel!
    @IBOutlet var cheapLabel: UILabel!
    @IBOutlet var musicLabel: UILabel!
    @IBOutlet var urlLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = detail[number!].name
        addressLabel.text = detail[number!].address
        wifiLabel.text = String(detail[number!].wifi)
        seatLabel.text = String(detail[number!].seat)
        tastyLabel.text = String(detail[number!].tasty)
        cheapLabel.text = String(detail[number!].cheap)
        musicLabel.text = String(detail[number!].music)
        urlLabel.text = detail[number!].url

        // Do any additional setup after loading the view.
    }
    

}
