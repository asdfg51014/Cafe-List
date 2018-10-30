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
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
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
//        if self.showCafeShop.count > 0 {
//            self.tableView.backgroundView?.isHidden = true
//            self.activityIndicator.stopAnimating()
//            UIApplication.shared.endIgnoringInteractionEvents()
//        } else {
//            self.tableView.backgroundView?.isHidden = false
//            self.activityIndicator.stopAnimating()
//            UIApplication.shared.endIgnoringInteractionEvents()
//        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.center = tableView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        tableView.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        get()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .always
        tableView.backgroundView = emptyView
        tableView.backgroundView?.isHidden = true

        navigationController?.hidesBarsOnSwipe = true
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.hidesBarsOnSwipe = false
//        navigationController?.setNavigationBarHidden(false, animated: true)
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
      
//
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showCafeShop.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CafeTableViewCell
        cell.shopName.text = showCafeShop[indexPath.row].name
        cell.shopAddress.text = showCafeShop[indexPath.row].address

        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        
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
        UIView.animate(withDuration: 0.3) {
            cell.alpha = 1
        }
    }
}
