//
//  CafeTableViewController.swift
//  CafeNomad
//
//  Created by Albert on 2018/10/23.
//  Copyright © 2018 Avarrt.C. All rights rvarrved.
//

import UIKit

class CafeTableViewController: UITableViewController {

    var a: Int?
    
    var cafeShop: [CafeAPI] = []
    
    var showCafeShop: [CafeAPI] = []
    
    var cityName: String?
    
    var shopwifi: Double?
    
    var shopSeat: Double?
    
    var shopLimit: Bool?
    
    var shopSocket: Bool?
    
    
    @IBOutlet var emptyView: UIView!

    func get(){
        CallAPI.callApi(city: cityName!, call: {(theCall) in
            self.cafeShop = theCall
            self.filter()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func filter(){
        showCafeShop = []
        showCafeShop = cafeShop.filter({$0.wifi == shopwifi && $0.seat == shopSeat})
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        get()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .always
        tableView.backgroundView = emptyView
        tableView.backgroundView?.isHidden = true

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
      
        if showCafeShop.count > 0 {
            tableView.backgroundView?.isHidden = true
        } else {
            tableView.backgroundView?.isHidden = false
        }
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showCafeShop.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CafeTableViewCell
        cell.shopName.text = showCafeShop[indexPath.row].name
        cell.shopAddress.text = showCafeShop[indexPath.row].address

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Send" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let sendSegue = segue.destination as! DetailViewController
                sendSegue.detail = showCafeShop
                sendSegue.number = indexPath.row
            }
        }
    }
    
    //MRAK: Animate
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 1.0) {
            cell.alpha = 1
        }
    }
}
