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
import SafariServices
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate, UITabBarControllerDelegate {

    var points: [CafeAPI] = []
    var cafeList: [CafeListMO] = []
    let locationManager = CLLocationManager()
    var cafeShopLatitude: Double?
    var cafeShopLongitude: Double?
    var userLatitude: Double?
    var userLongitube: Double?
    var cafeShopName: String?
    var cafeShopURL: String?
    var cafeShopCluster: String?
    var detailViewWidth: CGFloat?
    var tabBarHeight: CGFloat?
    var detailViewY: CGFloat?
    var detailViewHeight: CGFloat?
    var cafeListMo: CafeListMO!
    var adjustmentSaveIsOn = false
    var save: Bool?
    
    var fetchResultController: NSFetchedResultsController<CafeListMO>!
    
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var detailView: UIView!
    @IBOutlet var userLocation: UIButton!
    
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
    
    @IBAction func hiddenDetailViewButton(_ sender: UIButton) {
        setDetailViewHidden()
    }
    
    
    @IBAction func goToPointAction(_ sender: UIButton) {
        let cafeShop = CLLocationCoordinate2D(latitude: cafeShopLatitude!, longitude: cafeShopLongitude!)
        let userLocation = CLLocationCoordinate2D(latitude: userLatitude!, longitude: userLongitube!)
        let placeA = MKPlacemark(coordinate: cafeShop, addressDictionary: nil)
        let placeB = MKPlacemark(coordinate: userLocation, addressDictionary: nil)
        let miA = MKMapItem(placemark: placeA)
        let miB = MKMapItem(placemark: placeB)
        miA.name = cafeShopName
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        miA.openInMaps(launchOptions: options)
    }
    
    @IBAction func goToWebAction(_ sender: UIButton) {
        let url = URL(string: cafeShopURL!)
        let safariController = SFSafariViewController(url: url!)
        present(safariController, animated:  true, completion:  nil)
    }
    
    @IBAction func saveCafeShopAction(_ sender: UIButton) {
        adjustmentSaveIsOn = !adjustmentSaveIsOn
        print("adjustmentIsOn: \(adjustmentSaveIsOn)")
        adjustmentSaveIsOn ? (saveCafeShop.setImage(UIImage(named: "checkOn"), for: .normal)) : (saveCafeShop.setImage(UIImage(named: "checkOff"), for: .normal))
        adjustmentSaveIsOn ? (save = true) : (save = false)
        print("save: \(save!)")
        judgeUserTapSaveButtonStatus()
    }
    
    func judgeCoreDataHaveSave(){
        for adjustment in cafeList {
            if cafeShopName! == adjustment.name {
                adjustmentSaveIsOn = true
                saveCafeShop.setImage(UIImage(named: "checkOn"), for: .normal)
                break
            } else {
                adjustmentSaveIsOn = false
                saveCafeShop.setImage(UIImage(named: "checkOff"), for: .normal)
            }
        }
        adjustmentSaveIsOn ? print("\(cafeShopName!) has in CoreData.") : print("\(cafeShopName!) hasn't in CoreData")
    }
    
    func judgeUserTapSaveButtonStatus(){
        print("Save button is working")
        reloadCafeList()
        if save == true {
            if cafeList.count == 0 {
                saveDetailToCoreData()
            } else {}
            for adjustment in cafeList {
                if cafeShopName! != adjustment.name {
                    saveDetailToCoreData()
                    break
                }
            }
        } else if save == false {
            print(cafeList.count)
            print("oisnfoingoinsg")
            if cafeList.count != 0 {
                print("123\(cafeList.count)")
                for adjustment in cafeList {
                    if cafeShopName! == adjustment.name {
                        deleteDetailFormCoreData()
                        print("sccess")
                        break
                    }
                }
            }
        }
    }
    
    func reloadCafeList(){
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let request: NSFetchRequest<CafeListMO> = CafeListMO.fetchRequest()
            let context = appDelegate.persistentContainer.viewContext
            do {
                cafeList = try context.fetch(request)
            } catch {
                print(error)
            }
        }
    }
    
    func saveDetailToCoreData(){
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            cafeListMo = CafeListMO(context: appDelegate.persistentContainer.viewContext)
            for saveToCoreData in points {
                if saveToCoreData.name == cafeShopName {
                    cafeListMo.name = saveToCoreData.name
                    cafeListMo.address = saveToCoreData.address
                    cafeListMo.wifi = saveToCoreData.wifi
                    cafeListMo.seat = saveToCoreData.seat
                    cafeListMo.quiet = saveToCoreData.quiet
                    cafeListMo.tasty = saveToCoreData.tasty
                    cafeListMo.music = saveToCoreData.music
                    cafeListMo.limitedTime = saveToCoreData.limited_time
                    cafeListMo.socket = saveToCoreData.socket
                    cafeListMo.standingWork = saveToCoreData.standing_desk
                    cafeListMo.latitude = saveToCoreData.latitude
                    cafeListMo.longitude = saveToCoreData.longitude
                    appDelegate.saveContext()
                    print("Save \(saveToCoreData.name)")
                }
            }
            
        }
    }
    
    func deleteDetailFormCoreData(){
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            for adjustment in cafeList {
                if adjustment.name == cafeShopName! {
                    context.delete(adjustment)
                    appDelegate.saveContext()
                    print("Delete \(cafeShopName!)")
                    break
                }}}
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
    
    //MARK: setting DetailView Button Image
    func settingDetailView() {
        goToPoint.setImage(UIImage(named: "goToPointButton"), for: .normal)
        goToPoint.setTitle("", for: .normal)
        goToPoint.tintColor = .white
        goToPoint.imageEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        goToPoint.imageView?.contentMode = .scaleAspectFit
        
        goToWeb.setImage(UIImage(named: "internetButton"), for: .normal)
        goToWeb.setTitle("", for: .normal)
        goToWeb.tintColor = .white
        goToWeb.imageEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        goToWeb.imageView?.contentMode = .scaleAspectFit
        
        saveCafeShop.setImage(UIImage(named: "checkOff"), for: .normal)
        saveCafeShop.setTitle("", for: .normal)
        saveCafeShop.tintColor = .white
        saveCafeShop.setTitleColor(UIColor.white, for: .normal)
        saveCafeShop.imageEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        saveCafeShop.imageView?.contentMode = .scaleAspectFit
    }
    
    func setDetailViewInit(){
        detailView.translatesAutoresizingMaskIntoConstraints = true
        detailViewWidth = UIScreen.main.bounds.width
        tabBarHeight = tabBarController?.tabBar.frame.height
        detailViewY = UIScreen.main.bounds.height - tabBarHeight!
        detailViewHeight = 200
        detailView.frame = CGRect(x: 0, y: detailViewY!, width: detailViewWidth!, height: detailViewHeight!)
        userLocation.frame = CGRect(x: UIScreen.main.bounds.width - 60, y: detailViewY! - 60, width: 40, height: 40)
        
        
    }
    
    func setDetailViewHidden(){
        UIView.animate(withDuration: 0.5) {
            self.detailViewWidth = UIScreen.main.bounds.width
            self.tabBarHeight = self.tabBarController?.tabBar.frame.height
            self.detailViewY = UIScreen.main.bounds.height - self.tabBarHeight!
            self.detailViewHeight = 200
            self.detailView.frame = CGRect(x: 0, y: self.detailViewY!, width: self.detailViewWidth!, height: self.detailViewHeight!)
            self.userLocation.frame = CGRect(x: UIScreen.main.bounds.width - 60, y: self.detailViewY! - 60, width: 40, height: 40)
        }
    }
    
    func setDetailViewShow(){
        print("did press set detailviewshow")
        
        
        UIView.animate(withDuration: 0.5) {
            self.detailViewWidth = UIScreen.main.bounds.width
            self.tabBarHeight = self.tabBarController?.tabBar.frame.height
            self.detailViewY = UIScreen.main.bounds.height - self.tabBarHeight!
            self.detailViewHeight = 200
            self.detailView.frame = CGRect(x: 0, y: self.detailViewY! - 200, width: self.detailViewWidth!, height: self.detailViewHeight!)
            self.userLocation.frame = CGRect(x: UIScreen.main.bounds.width - 60, y: self.detailViewY! - 260, width: 40, height: 40)
            print("show detail view")
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
    
    func fetchRequestCafeList() {
        let fetchRequest: NSFetchRequest<CafeListMO> = CafeListMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            do {
                try! fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    cafeList = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
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
        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else {
            return CafeAnnotationView(annotation: annotation as! MKAnnotation, reuseIdentifier: CafeAnnotationView.ReuseID)
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let ann = MKPointAnnotation()
        cafeShopLatitude = view.annotation?.coordinate.latitude
        cafeShopLongitude = view.annotation?.coordinate.longitude
        
        if cafeShopLatitude == userLatitude && cafeShopLongitude == userLongitube {
            setDetailViewHidden()
        } else {
            cafeShopName = (view.annotation?.title)!
            cafeShopCluster = (view.annotation?.subtitle)!
            fetchRequestCafeList()
            judgeCoreDataHaveSave()
            if cafeShopCluster == nil {
                shopName.text = (view.annotation?.title)!
                setDetailViewShow()
                ann.coordinate = CLLocationCoordinate2D(latitude: cafeShopLatitude!, longitude: cafeShopLongitude!)
                mapView.setCenter(ann.coordinate, animated: true)
                let region = MKCoordinateRegion(center: ann.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
                self.mapView.setRegion(region, animated: true)
                for point in points {
                    if point.name == (view.annotation?.title)! {
                        shopAddress.text = point.address
                        judge(p: shopWifi, n: point.wifi)
                        judge(p: shopSeat, n: point.seat)
                        judge(p: shopTasty, n: Double(point.tasty))
                        judge(p: shopMusic, n: Double(point.music))
                        judgeLimitLabel(point.limited_time)
                        if point.url == "" {
                            goToWeb.isEnabled = false
                            cafeShopURL = point.url
                        } else {
                            goToWeb.isEnabled = true
                            cafeShopURL = point.url
                        }
                    }
                }
            } else {
                print(cafeShopCluster)
                setDetailViewHidden()
                ann.coordinate = CLLocationCoordinate2D(latitude: cafeShopLatitude!, longitude: cafeShopLongitude!)
                mapView.setCenter(ann.coordinate, animated: true)
                let region = MKCoordinateRegion(center: ann.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        setDetailViewHidden()
        
    }
    
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        if viewController == viewController?[2] {
//            print("viewController2")
//        }
//    }
    
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
        settingDetailView()
        setDetailViewInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingNavigationBar()
        mapView.layoutIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setDetailViewHidden()
    }
}
