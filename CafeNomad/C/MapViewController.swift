//
//  MapViewController.swift
//  CafeNomad
//
//  Created by Albert on 2018/11/4.
//  Copyright © 2018 Albert.C. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Foundation


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITabBarDelegate {

    var points: [CafeAPI] = []
    
    let locationManager = CLLocationManager()
    
    var userLatitude: Double?
    
    var userLongitube: Double?
    
    var detailViewWidth: CGFloat?
    var tabBarHeight: CGFloat?
    var detailViewY: CGFloat?
    var detailViewHeight: CGFloat?
    
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var detailView: UIView!
    
    @IBOutlet var shopName: UILabel!
    @IBOutlet var shopAddress: UILabel!
    @IBOutlet var shopWifi: UIImageView!
    @IBOutlet var shopSeat: UIImageView!
    @IBOutlet var shopTasty: UIImageView!
    @IBOutlet var shopMusic: UIImageView!
    @IBOutlet var shopLimitetTime: UILabel!
    
    
    @IBOutlet var goToPoint: UIButton!
    @IBOutlet var goToWeb: UIButton!
    @IBOutlet var saveCafeShop: UIButton!
    
    
    
    @IBAction func userLocation(_ sender: UIButton) {
        let ann = MKPointAnnotation()
        ann.coordinate = CLLocationCoordinate2D(latitude: userLatitude!, longitude: userLongitube!)
        
        mapView.setCenter(ann.coordinate, animated: true)
    }
    
    override func loadView() {
        super.loadView()
        registerAnnotationViewClasses()
    }
    
    func judge(p: UIImageView, n: Double){
        if n == 0 {
            p.image = UIImage(named: "star1")
        } else if n == 0.5 {
            p.image = UIImage(named: "star2")
        } else if n == 1 {
            p.image = UIImage(named: "star3")
        } else if n == 1.5 {
            p.image = UIImage(named: "star4")
        } else if n == 2 {
            p.image = UIImage(named: "star5")
        } else if n == 2.5 {
            p.image = UIImage(named: "star6")
        } else if n == 3 {
            p.image = UIImage(named: "star7")
        } else if n == 3.5 {
            p.image = UIImage(named: "star8")
        } else if n == 4 {
            p.image = UIImage(named: "star9")
        } else if n == 4.5 {
            p.image = UIImage(named: "star10")
        } else if n == 5 {
            p.image = UIImage(named: "star11")
        }
    }
    
    func judgeLimitLabel(_ message: String){
        switch message {
        case "yes":
            shopLimitetTime.text = "一律有限時"
        case "maybe":
            shopLimitetTime.text = "看情況限時"
        case "no":
            shopLimitetTime.text = "一律不限時"
        default:
            shopLimitetTime.text = "無資料"
        }
    }
    
    func detailViewInit(){
        self.detailViewWidth = UIScreen.main.bounds.width
        self.tabBarHeight = self.tabBarController?.tabBar.frame.height
        self.detailViewY = UIScreen.main.bounds.height - self.tabBarHeight!
        self.detailViewHeight = 200
        self.detailView.frame = CGRect(x: 0, y: self.detailViewY!, width: self.detailViewWidth!, height: self.detailViewHeight!)
    }
    
    func setDetailViewHidden(){
        UIView.animate(withDuration: 0.5) {
            self.detailViewWidth = UIScreen.main.bounds.width
            self.tabBarHeight = self.tabBarController?.tabBar.frame.height
            self.detailViewY = UIScreen.main.bounds.height - self.tabBarHeight!
            self.detailViewHeight = 200
            self.detailView.frame = CGRect(x: 0, y: self.detailViewY!, width: self.detailViewWidth!, height: self.detailViewHeight!)
        }
    }
    
    func setDetailViewShow(){
        UIView.animate(withDuration: 0.5) {
            self.detailViewWidth = UIScreen.main.bounds.width
            self.tabBarHeight = self.tabBarController?.tabBar.frame.height
            self.detailViewY = UIScreen.main.bounds.height - 200 - self.tabBarHeight!
            self.detailViewHeight = 200
            self.detailView.frame = CGRect(x: 0, y: self.detailViewY!, width: self.detailViewWidth!, height: self.detailViewHeight!)
        }
        
        
    }
    
    func settingNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = UIColor.lightGray
        navigationController?.navigationBar.tintColor = .brown
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.brown]
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.brown]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        userLatitude = location.coordinate.latitude
        userLongitube = location.coordinate.longitude
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            let ann = MKPointAnnotation()
            ann.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            mapView.setCenter(ann.coordinate, animated: true)
            let region = MKCoordinateRegion(center: ann.coordinate, latitudinalMeters: 450, longitudinalMeters: 450)
            self.mapView.setRegion(region, animated: true)
            locationManager.distanceFilter = CLLocationDistance(10)
            
        }
    }

    private func registerAnnotationViewClasses(){
        mapView.register(CafeAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(CafeAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else {
            return CafeAnnotationView(annotation: annotation as! MKAnnotation, reuseIdentifier: CafeAnnotationView.ReuseID)
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        setDetailViewShow()
        let ann = MKPointAnnotation()
        ann.coordinate = CLLocationCoordinate2D(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!)
        mapView.setCenter(ann.coordinate, animated: true)
        let region = MKCoordinateRegion(center: ann.coordinate, latitudinalMeters: 450, longitudinalMeters: 450)
        self.mapView.setRegion(region, animated: true)
        
        shopName.text = (view.annotation?.title)!
        for point in points {
            if point.name == (view.annotation?.title)! {
                shopAddress.text = point.address
                judge(p: shopWifi, n: point.wifi)
                judge(p: shopSeat, n: point.seat)
                judge(p: shopTasty, n: Double(point.tasty))
                judge(p: shopMusic, n: Double(point.music))
                judgeLimitLabel(point.limited_time)
                
            }
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        setDetailViewHidden()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsBuildings = true
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
        settingNavigationBar()
        
        
        
        goToPoint.imageEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        goToPoint.imageView?.contentMode  = .scaleAspectFit
        goToWeb.imageView?.image = UIImage(named: "internetButton")
        goToWeb.imageEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        goToWeb.imageView?.contentMode = .scaleAspectFit
        saveCafeShop.imageEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        saveCafeShop.imageView?.contentMode = .scaleAspectFit
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingNavigationBar()
        //        registerAnnotationViewClasses()
        //        reloadInputViews()
        mapView.layoutIfNeeded()
        detailViewInit()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
}
