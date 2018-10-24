//
//  HomeViewController.swift
//  CafeNomad
//
//  Created by Albert on 2018/10/23.
//  Copyright © 2018 Albert.C. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var wifiCount: Double?
    
    var seatCount: Double?
    
    var limitBool: Bool = true
    
    var socketBool: Bool = true
    
    let citys = [String](arrayLiteral: "All", "Taipei", "Keelung", "Taoyuan", "Hsinchu", "Miaoli", "Taichung", "Nantou", "Changhua", "Yunlin", "Chiayi", "Tainan", "Kaohsiung", "Pingtung", "Yilan", "Hualien", "Taitung", "Penghu", "Lienchiang")

    @IBOutlet var backGroungImage: UIImageView!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var viewcontroller: UIView!
    @IBOutlet var wifiNumber: UILabel!
    @IBOutlet var wifiSilder: UISlider!
    @IBOutlet var seatsNumber: UILabel!
    @IBOutlet var seatsSilder: UISlider!
    @IBOutlet var limitTime: UISwitch!
    @IBOutlet var socket: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let cityPicker = UIPickerView()
        cityTextField.inputView = cityPicker
        cityPicker.delegate = self
        cityPicker.layer.cornerRadius = 5
        cityPicker.clipsToBounds = true
        
        wifiSilder.minimumValue = 0
        wifiSilder.maximumValue = 10
        wifiSilder.value = 5
        
        seatsSilder.minimumValue = 0
        seatsSilder.maximumValue = 10
        seatsSilder.value = 5
        
        limitTime.isOn = true
        
        socket.isOn = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if cityTextField.text == "All" {
            
        }
        if segue.identifier == "SearchCity" {
            let segueCity = segue.destination as! CafeTableViewController
            if cityTextField.text == "All" {
                segueCity.cityName = ""
            } else {
                segueCity.cityName = cityTextField.text
            }
            segueCity.shopwifi = wifiCount
            segueCity.shopSeat = seatCount
            segueCity.shopLimit = limitBool
            segueCity.shopSocket = socketBool
        }
        
    }
    
    //MARK: UIPickerView Delegation
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return citys.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return citys[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cityTextField.text = citys[row]
    }
    
    @IBAction func wifiSilderAction(_ sender: UISlider) {
        var a = Int(wifiSilder.value)
        var b = Double(a) * 0.5
        wifiCount = b
        wifiSilder.value = Float(a)
        wifiNumber.text = String(b)
    }
    
    @IBAction func seatSilderAction(_ sender: UISlider) {
        var a = Int(seatsSilder.value)
        var b = Double(a) * 0.5
        seatCount = b
        seatsSilder.value = Float(a)
        seatsNumber.text = String(b)
    }
    
    @IBAction func limitTimeAction(_ sender: UISwitch) {
        if limitTime.isOn == true {
            limitBool = true
        } else {
            limitBool = false
        }
    }
    
    @IBAction func socketAction(_ sender: UISwitch) {
        if socket.isOn == true {
            socketBool = true
        } else {
            socketBool = false
        }
    }
    
    @IBAction func limitAction(_ sender: UISwitch) {
        if limitTime.isOn == true {
            limitBool = true
        } else {
            limitBool = false
        }
    }
    
    @IBAction func socketBoolAction(_ sender: UISwitch) {
        if socket.isOn == true {
            socketBool = true
        } else {
            socketBool = false
        }
    }
    
    
    
    
    
}
