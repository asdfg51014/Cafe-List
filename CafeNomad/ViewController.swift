//
//  ViewController.swift
//  CafeNomad
//
//  Created by Albert on 2018/10/23.
//  Copyright © 2018 Albert.C. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var cafeShop: [CafeAPI] = []
    
    func get(){
        CallAPI.callApi(call: {(theCall) in
            self.cafeShop = theCall
            DispatchQueue.main.async {
                
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        get()
        
    }


}

