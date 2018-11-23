//
//  DetailMapViewController.swift
//  CafeNomad
//
//  Created by Albert on 2018/11/7.
//  Copyright © 2018 Albert.C. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var shopName: String?
    var latitude: Double?
    var longitude: Double?
    var userLatitude: Double?
    var userLongitude: Double?
    
    let locationManager = CLLocationManager()
    
    
    @IBOutlet var detailMapView: MKMapView!
    
    @IBAction func userLoaction(_ sender: UIButton) {
        let ann = MKPointAnnotation()
        ann.coordinate = CLLocationCoordinate2D(latitude: userLatitude!, longitude: userLongitude!)
        detailMapView.setCenter(ann.coordinate, animated: false)
    }
    
    @IBAction func goTpShop(_ sender: UIButton) {
        let cafeShop = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        let userLocation = CLLocationCoordinate2D(latitude: userLatitude!, longitude: userLongitude!)
        let placeA = MKPlacemark(coordinate: cafeShop, addressDictionary: nil)
        let placeB = MKPlacemark(coordinate: userLocation, addressDictionary: nil)
        
        let miA = MKMapItem(placemark: placeA)
        let miB = MKMapItem(placemark: placeB)
        miA.name = shopName!
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        miA.openInMaps(launchOptions: options)
    }
    
    @IBAction func shopLocation(_ sender: UIButton) {
        let ann = MKPointAnnotation()
        ann.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        detailMapView.setCenter(ann.coordinate, animated: false)
        let region = MKCoordinateRegion(center: ann.coordinate, latitudinalMeters: 350, longitudinalMeters: 350)
        detailMapView.setRegion(region, animated: false)
    }
    
    //MARK: functions
    
    func shopLocation(_ latitude: Double, _ longitude: Double) {
        let ann = MKPointAnnotation()
        ann.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        ann.title = shopName
        detailMapView.addAnnotation(ann)
        detailMapView.setCenter(ann.coordinate, animated: false)
        let region = MKCoordinateRegion(center: ann.coordinate, latitudinalMeters: 350, longitudinalMeters: 350)
        detailMapView.setRegion(region, animated: false)
    }
    
    func registerAnnotationViewClass(){
        detailMapView.register(CafeAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shopLocation(latitude!, longitude!)
        
        registerAnnotationViewClass()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation is MKUserLocation {
            return nil
        } else {
            return CafeAnnotationView(annotation: annotation as! MKAnnotation, reuseIdentifier: CafeAnnotationView.ReuseID)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        userLatitude = location.coordinate.latitude
        userLongitude = location.coordinate.longitude
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            let ann = MKPointAnnotation()
            ann.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            locationManager.distanceFilter = CLLocationDistance(10)
        }
        
        
    }
    
    
}
