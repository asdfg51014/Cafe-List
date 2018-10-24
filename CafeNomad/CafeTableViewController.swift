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
    
    
    
    
//    let firstURL = "https://cafenomad.tw/api/v1.2/cafes/"
//    func callApi(call: @escaping ([CafeAPI]) -> Void) {
//        let city = cityName?.lowercased()
//        print(city)
//        var callCafeApi = [CafeAPI]()
//        print(city)
//        let urlObj = URL(string: firstURL + city!)
//        let task = URLSession.shared.dataTask(with: urlObj!) { (data, response, error) in
//            guard let getData = data else { return }
//            do {
//                let dataInfo = try JSONDecoder().decode([CafeAPI].self, from: getData)
//                callCafeApi = dataInfo
//                call(callCafeApi)
//
//            } catch {
//                print("error")
//            }
//            }.resume()
//    }
    
    func get(){
        CallAPI.callApi(city: cityName!, call: {(theCall) in
            self.cafeShop = theCall
            print(self.cafeShop)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func filter(){
        showCafeShop = []
        for select in cafeShop {
            if select.wifi == shopwifi {
                if select.seat == shopSeat {
//                    if select.limited_time == shopLimit
                    showCafeShop.append(select)
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        get()
//        filter()
//        print(showCafeShop)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cafeShop.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = cafeShop[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Send" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let sendSegue = segue.destination as! DetailViewController
                sendSegue.detail = cafeShop
                sendSegue.number = indexPath.row
            }
        }
    }
}
