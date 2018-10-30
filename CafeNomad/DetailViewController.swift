//
//  DetailViewController.swift
//  CafeNomad
//
//  Created by Albert on 2018/10/23.
//  Copyright © 2018 Albert.C. All rights reserved.
//

import UIKit
import SafariServices
import MapKit

class DetailViewController: UIViewController {

    var detail: [CafeAPI] = []
    
    var starsImage = ["star1", "star2", "star3", "star4", "star5", "star6", "star7", "star8", "star9", "star10", "star11"]
    
    var number: Int?
    
    @IBOutlet var shopName: UILabel!
    @IBOutlet var shopAddress: UILabel!
    @IBOutlet var wifiImage: UIImageView!
    @IBOutlet var seatImage: UIImageView!
    @IBOutlet var quietImage: UIImageView!
    @IBOutlet var tasty: UIImageView!
    @IBOutlet var musicImage: UIImageView!
    
    @IBOutlet var limitedTimeLabel: UILabel!
    @IBOutlet var socketLabel: UILabel!
    @IBOutlet var standingWorkLabel: UILabel!
    
    @IBOutlet var mapView: MKMapView!
    
    
    @IBOutlet var safariButton: UIButton!
    
    @IBAction func turnSafariPage(_ sender: UIButton) {
        let url = URL(string: detail[number!].url)
        let safariController = SFSafariViewController(url: url!)
        present(safariController, animated:  true, completion:  nil)
    }
    
    func judge(p: UIImageView, n: Double){
        if n == 0 {
            p.image = UIImage(named: starsImage[0])
        } else if n == 0.5 {
            p.image = UIImage(named: starsImage[1])
        } else if n == 1 {
            p.image = UIImage(named: starsImage[2])
        } else if n == 1.5 {
            p.image = UIImage(named: starsImage[3])
        } else if n == 2 {
            p.image = UIImage(named: starsImage[4])
        } else if n == 2.5 {
            p.image = UIImage(named: starsImage[5])
        } else if n == 3 {
            p.image = UIImage(named: starsImage[6])
        } else if n == 3.5 {
            p.image = UIImage(named: starsImage[7])
        } else if n == 4 {
            p.image = UIImage(named: starsImage[8])
        } else if n == 4.5 {
            p.image = UIImage(named: starsImage[9])
        } else if n == 5 {
            p.image = UIImage(named: starsImage[10])
        }
    }
    
    func judgeLimitLabel(_ message: String){
        switch message {
        case "yes":
            limitedTimeLabel.text = "一律有限時"
        case "maybe":
            limitedTimeLabel.text = "看情況限時"
        case "no":
            limitedTimeLabel.text = "一律不限時"
        default:
            limitedTimeLabel.isHidden = true
        }
    }
    
    func judgeSocketLabel(_ message: String) {
        switch message {
        case "yes":
            socketLabel.text = "插座很多"
        case "maybe":
            socketLabel.text = "看座位"
        case "no":
            socketLabel.text = "插座很少"
        default:
            socketLabel.isHidden = true
        }
    }
    
    func judgeStandingWorkLabel(_ message: String) {
        switch message {
        case "yes":
            standingWorkLabel.text = "有些座位可以"
        case "no":
            standingWorkLabel.text = "沒有站位"
        default:
            standingWorkLabel.isHidden = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if detail[number!].url == "" {
            safariButton.isHidden = true
        }
        shopName.adjustsFontSizeToFitWidth = true
        shopName.text = detail[number!].name
        shopAddress.adjustsFontSizeToFitWidth = true
        shopAddress.text = detail[number!].address
        limitedTimeLabel.adjustsFontSizeToFitWidth = true
        socketLabel.adjustsFontSizeToFitWidth = true
        standingWorkLabel.adjustsFontSizeToFitWidth = true
        
        judge(p: wifiImage, n: detail[number!].wifi)
        judge(p: seatImage, n: detail[number!].seat)
        judge(p: quietImage, n: Double(detail[number!].quiet))
        judge(p: tasty, n: Double(detail[number!].tasty))
        judge(p: musicImage, n: Double(detail[number!].music))
        
        judgeLimitLabel(detail[number!].limited_time)
        judgeSocketLabel(detail[number!].socket)
        judgeStandingWorkLabel(detail[number!].standing_desk)
        
//        print(detail[number!].latitude)
        
        let ann = MKPointAnnotation()
        ann.coordinate = CLLocationCoordinate2D(latitude: Double(detail[number!].latitude)!, longitude: Double(detail[number!].longitude)!)
        ann.title = detail[number!].name
        mapView.addAnnotation(ann)
        mapView.setCenter(ann.coordinate, animated: false)
        let region = MKCoordinateRegion(center: ann.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
        self.mapView.setRegion(region, animated: false)
        
        
        
    }
    

}
