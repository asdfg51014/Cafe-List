//
//  CafeTableViewController.swift
//  CafeNomad
//
//  Created by Albert on 2018/10/23.
//  Copyright © 2018 Albert.C. All rights reserved.
//

import UIKit

class CafeTableViewController: UITableViewController {

    var a: Int?
    
    var cafeShop: [CafeAPI] = []
    
    var cityName: String?
    
//    var shopwifi: Double = 0.0
    
    
    
    
    let firstURL = "https://cafenomad.tw/api/v1.2/cafes/"
    
    
    func callApi(call: @escaping ([CafeAPI]) -> Void) {
        let city = cityName?.lowercased()
        print(city)
        var callCafeApi = [CafeAPI]()
        print(city)
        let urlObj = URL(string: firstURL + city!)
        let task = URLSession.shared.dataTask(with: urlObj!) { (data, response, error) in
            guard let getData = data else { return }
            do {
                let dataInfo = try JSONDecoder().decode([CafeAPI].self, from: getData)
                callCafeApi = dataInfo
                call(callCafeApi)
                
            } catch {
                print("error")
            }
            }.resume()
    }
    
    func get(){
        callApi(call: {(theCall) in
            self.cafeShop = theCall
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        get()
        
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

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
