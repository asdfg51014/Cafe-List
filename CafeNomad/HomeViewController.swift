//
//  HomeViewController.swift
//  CafeNomad
//
//  Created by Albert on 2018/10/23.
//  Copyright © 2018 Albert.C. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var wifiCount: Double = 5
    
    var seatCount: Double = 5
    
    var limitBool: String?
    
    var socketBool: String?
    
    var limitB1: Int = 0, limitB2: Int = 0, limitB3: Int = 0
    
    var socketB1: Int = 0, socketB2: Int = 0, socketB3: Int = 0
    
    
    let citys = [String](arrayLiteral: "All", "Taipei", "Keelung", "Taoyuan", "Hsinchu", "Miaoli", "Taichung", "Nantou", "Changhua", "Yunlin", "Chiayi", "Tainan", "Kaohsiung", "Pingtung", "Yilan", "Hualien", "Taitung", "Penghu", "Lienchiang")

//    @IBOutlet var backGroungImage: UIImageView!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var viewcontroller: UIView!
    @IBOutlet var wifiNumber: UILabel!
    @IBOutlet var wifiSilder: UISlider!
    @IBOutlet var seatsNumber: UILabel!
    @IBOutlet var seatsSilder: UISlider!
    
    @IBOutlet var limitButton1: UIButton!
    @IBOutlet var linitButton2: UIButton!
    @IBOutlet var limitButton3: UIButton!
    
    @IBOutlet var socketButton1: UIButton!
    @IBOutlet var socketButton2: UIButton!
    @IBOutlet var socketButton3: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        if let customFont = UIFont(name: "American Typewriter", size: 40.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1), NSAttributedString.Key.font: customFont]
        }
        
        let cityPicker = UIPickerView()
        cityTextField.inputView = cityPicker
        cityPicker.delegate = self
        cityPicker.layer.cornerRadius = 5
        cityPicker.clipsToBounds = true
        
        wifiSilder.minimumValue = 0
        wifiSilder.maximumValue = 10
        wifiSilder.value = 10
        
        seatsSilder.minimumValue = 0
        seatsSilder.maximumValue = 10
        seatsSilder.value = 10
        
        limitButton1.backgroundColor = .gray
        linitButton2.backgroundColor = .gray
        limitButton3.backgroundColor = .gray
        
        socketButton1.backgroundColor = .gray
        socketButton2.backgroundColor = .gray
        socketButton3.backgroundColor = .gray
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
//            segueCity.shopLimit =
//            segueCity.shopSocket =
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
    
    //MARK: Limited Buttons
    @IBAction func limitButtonA(_ sender: UIButton) {
        limitB1 += 1
        if limitB1 % 2 == 0 {
            self.limitButton1.setTitleColor(.white, for: .normal)
            self.limitButton1.backgroundColor = .gray
        } else {
            self.limitButton1.setTitleColor(.gray, for: .normal)
            self.limitButton1.backgroundColor = .white
            limitB2 = 0
            self.linitButton2.setTitleColor(.white, for: .normal)
            self.linitButton2.backgroundColor = .gray
            limitB3 = 0
            self.limitButton3.setTitleColor(.white, for: .normal)
            self.limitButton3.backgroundColor = .gray
        }
    }
    
    @IBAction func limitButtonB(_ sender: UIButton) {
        limitB2 += 1
        if limitB2 % 2 == 0 {
            self.linitButton2.setTitleColor(.white, for: .normal)
            self.linitButton2.backgroundColor = .gray
        } else {
            self.linitButton2.setTitleColor(.gray, for: .normal)
            self.linitButton2.backgroundColor = .white
            limitB1 = 0
            self.limitButton1.setTitleColor(.white, for: .normal)
            self.limitButton1.backgroundColor = .gray
            limitB3 = 0
            self.limitButton3.setTitleColor(.white, for: .normal)
            self.limitButton3.backgroundColor = .gray
        }
    }
    
    @IBAction func limitButtonC(_ sender: UIButton) {
        limitB3 += 1
        if limitB3 % 2 == 0 {
            self.limitButton3.setTitleColor(.white, for: .normal)
            self.limitButton3.backgroundColor = .gray
        } else {
            self.limitButton3.setTitleColor(.gray, for: .normal)
            self.limitButton3.backgroundColor = .white
            limitB2 = 0
            self.linitButton2.setTitleColor(.white, for: .normal)
            self.linitButton2.backgroundColor = .gray
            limitB1 = 0
            self.limitButton1.setTitleColor(.white, for: .normal)
            self.limitButton1.backgroundColor = .gray
        }
    }
    
    //MARK: Socket Buttons
    @IBAction func socketButtonA(_ sender: UIButton) {
        socketB1 += 1
        if socketB1 % 2 == 0 {
            self.socketButton1.setTitleColor(.white, for: .normal)
            self.socketButton1.backgroundColor = .gray
        } else {
            self.socketButton1.setTitleColor(.gray, for: .normal)
            self.socketButton1.backgroundColor = .white
            socketB2 = 0
            self.socketButton2.setTitleColor(.white, for: .normal)
            self.socketButton2.backgroundColor = .gray
            socketB2 = 0
            self.socketButton3.setTitleColor(.white, for: .normal)
            self.socketButton3.backgroundColor = .gray
        }
    }
    
    @IBAction func socketButtonB(_ sender: UIButton) {
        socketB2 += 1
        if socketB2 % 2 == 0 {
            self.socketButton2.setTitleColor(.white, for: .normal)
            self.socketButton2.backgroundColor = .gray
        } else {
            self.socketButton2.setTitleColor(.gray, for: .normal)
            self.socketButton2.backgroundColor = .white
            limitB1 = 0
            self.socketButton1.setTitleColor(.white, for: .normal)
            self.socketButton1.backgroundColor = .gray
            limitB3 = 0
            self.socketButton3.setTitleColor(.white, for: .normal)
            socketButton3.backgroundColor = .gray
        }
    }
    
    @IBAction func socketButtonC(_ sender: UIButton) {
        socketB3 += 1
        if socketB3 % 2 == 0 {
            self.socketButton3.setTitleColor(.white, for: .normal)
            self.socketButton3.backgroundColor = .gray
        } else {
            self.socketButton3.setTitleColor(.gray, for: .normal)
            self.socketButton3.backgroundColor = .white
            limitB2 = 0
            self.socketButton1.setTitleColor(.white, for: .normal)
            self.socketButton1.backgroundColor = .gray
            limitB1 = 0
            self.socketButton2.setTitleColor(.white, for: .normal)
            self.socketButton2.backgroundColor = .gray
        }
    }
    
    
}
