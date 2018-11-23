//
//  SearchPageViewController.swift
//  CafeNomad
//
//  Created by Albert on 2018/11/2.
//  Copyright © 2018 Albert.C. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }}
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }}
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }}}

class SearchPageViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource {
    
    let citys: [(e: String, c: String)] = [("", "不限"), ("Taipei", "臺北"), ("Keelung", "基隆"), ("Taoyuan", "桃園"), ("Hsinchu", "新竹"), ("Miaoli", "苗栗"), ("Taichung", "臺中"), ("Nantou", "南投"), ("Changhua", "彰化"), ("Yunlin", "雲林"), ("Chiayi", "嘉義"), ("Tainan", "臺南"), ("Kaohsiung", "高雄"), ("Pingtung", "屏東"), ("Yilan", "宜蘭"), ("Hualien", "花蓮"), ("Taitung", "臺東"), ("Penghu", "澎湖"), ("Lienchiang", "連江")]
    
    var judgCity = ""
    
    var judgWifi = false
    
    var judgSocket = false
    
    var judgStandingWork = false
    
    var judeLimitedTime = 1
    
    var judgStart = false
    
    @IBOutlet var wifiSwitch: UISwitch!
    @IBOutlet var sockerSwitch: UISwitch!
    @IBOutlet var standingWorkSwitch: UISwitch!
    @IBOutlet var limitTimeSegment: UISegmentedControl!
    @IBOutlet var cityTextField: UITextField!
    
    @IBAction func wifiSwitchAction(_ sender: UISwitch) {
        if wifiSwitch.isOn {
            judgWifi = true
        } else {
            judgWifi = false
        }
    }
    
    @IBAction func socketSwitchAcion(_ sender: UISwitch) {
        if sockerSwitch.isOn {
            judgSocket = true
        } else {
            judgSocket = false
        }
    }
    
    @IBAction func standingWorkSwitchAction(_ sender: UISwitch) {
        if standingWorkSwitch.isOn {
            judgStandingWork = true
        } else {
            judgStandingWork = false
        }
    }
    
    @IBAction func limitedTimeSegmentControl(_ sender: UISegmentedControl) {
        judeLimitedTime = limitTimeSegment.selectedSegmentIndex
    }
    
    @IBAction func sendBackSearch(_ sender: UIButton) {
        for chouseCity in citys {
            if chouseCity.c == cityTextField.text {
                judgCity = chouseCity.e.lowercased()
//                judgCity = a
                
            }
        }
        performSegue(withIdentifier: "backFromSearch", sender: nil)
    }
    
    func setPickerView(){
        let cityPicker = UIPickerView()
        cityTextField.inputView = cityPicker
        cityPicker.delegate = self
        cityTextField.placeholder = "選擇城市"
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setPickerView()
        wifiSwitch.isOn = false
        sockerSwitch.isOn = false
        standingWorkSwitch.isOn = false
        limitTimeSegment.selectedSegmentIndex = 1
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return citys.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return citys[row].c
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cityTextField.text = citys[row].c
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backFromSearch" {
            let hpVC = segue.destination as? HomePageViewController
            hpVC?.cityName = judgCity
            hpVC?.judfWifi = judgWifi
            hpVC?.judgSocket = judgSocket
            hpVC?.judeStandingTime = judgStandingWork
            hpVC?.judgLimited = judeLimitedTime
            hpVC?.sendcondition = true
        }
    }
}
