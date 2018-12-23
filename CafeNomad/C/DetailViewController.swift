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
import CoreData

class DetailViewController: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate {
    
    var detailName: String?
    
    var detailAddress: String?
    
    var detailWifi: Double?
    
    var detailQuite: Float?
    
    var detailSeat: Double?
    
    var detailTasty: Float?
    
    var detailMusic: Float?
    
    var detailLimitedTiime: String?
    
    var detailSocket: String?
    
    var detailStandingDesk: String?
    
    var detailUrl: String?
    
    var detailLatitude: String?
    
    var detailLongitude: String?
    
    var starsImage = ["star1", "star2", "star3", "star4", "star5", "star6", "star7", "star8", "star9", "star10", "star11"]
    
    var number: Int?
    
    var cafeListMo: CafeListMO!
    
    var cafeList: [CafeListMO] = []
    
    var saveImage = ["checkOn", "checkOff"]
    
    var adjustmentSaveIsOn = false
    
    var save: Bool?
    
    var fetchResultController: NSFetchedResultsController<CafeListMO>!
    
    let app = UIApplication.shared.delegate as? AppDelegate
    
    var viewContext: NSManagedObjectContext!
    
    
    
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
    
    @IBOutlet var saveButton: UIButton!
    
    @IBOutlet var safariButton: UIButton!
    
    @IBAction func turnSafariPage(_ sender: UIButton) {
        let url = URL(string: detailUrl!)
        let safariController = SFSafariViewController(url: url!)
        present(safariController, animated:  true, completion:  nil)
        print(detailUrl!)
    }
    
    @IBAction func shareButton(_ sender: UIBarButtonItem) {
        let activityVC: UIActivityViewController
        if detailUrl != "" {
            activityVC = UIActivityViewController(activityItems: [detailName, detailAddress, detailUrl], applicationActivities: nil)
        } else {
            activityVC = UIActivityViewController(activityItems: [detailName, detailAddress], applicationActivities: nil)
        }
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func saveCafeShop(_ sender: UIButton) {
        adjustmentSaveIsOn = !adjustmentSaveIsOn
        print("adjustmentIsOn: \(adjustmentSaveIsOn)")
        adjustmentSaveIsOn ? (saveButton.setImage(UIImage(named: saveImage[0]), for: .normal)) : (saveButton.setImage(UIImage(named: saveImage[1]), for: .normal))
        adjustmentSaveIsOn ? (save = true) : (save = false)
        judgeUserTapSaveButtonStatus()
    }
    //view did load to use
    func judgeCoreDataHaveSave(){
        for adjustment in cafeList {
            if detailName == adjustment.name {
                adjustmentSaveIsOn = true
                saveButton.setImage(UIImage(named: "checkOn"), for: .normal)
                break
            } else {
                adjustmentSaveIsOn = false
                saveButton.setImage(UIImage(named: "checkOff"), for: .normal)
            }
        }
        adjustmentSaveIsOn ? print("\(detailName!) has in CoreData.") : print("\(detailName!) hasn't in CoreData")
    }
    
    func judgeUserTapSaveButtonStatus(){
        print("Save button is working")
        reloadCafeList()
        if save == true {
            if cafeList.count == 0 {
                saveDetailToCoreData()
            } else {}
            for adjustment in cafeList {
                if detailName != adjustment.name {
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
                    if detailName == adjustment.name {
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
            cafeListMo.name = detailName
            cafeListMo.address = detailAddress
            cafeListMo.wifi = detailWifi!
            cafeListMo.seat = detailSeat!
            cafeListMo.quiet = detailQuite!
            cafeListMo.tasty = detailTasty!
            cafeListMo.music = detailMusic!
            cafeListMo.limitedTime = detailLimitedTiime
            cafeListMo.socket = detailSocket
            cafeListMo.standingWork = detailStandingDesk!
            cafeListMo.latitude = detailLatitude
            cafeListMo.longitude = detailLongitude
            cafeListMo.url = detailUrl
            appDelegate.saveContext()
            print("Save \(detailName!)")
        }
    }
    
    func deleteDetailFormCoreData(){
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            for adjustment in cafeList {
                if adjustment.name == detailName {
                    context.delete(adjustment)
                    appDelegate.saveContext()
                    print("Delete \(detailName!)")
                    break
                }}}
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
    
    func judgSet(){
        judge(p: wifiImage, n: detailWifi!)
        judge(p: seatImage, n: detailSeat!)
        judge(p: quietImage, n: Double(detailQuite!))
        judge(p: tasty, n: Double(detailTasty!))
        judge(p: musicImage, n: Double(detailMusic!))
        
        judgeLimitLabel(detailLimitedTiime!)
        judgeSocketLabel(detailSocket!)
        judgeStandingWorkLabel(detailStandingDesk!)
    }
    
    func cafeShopInMap(){
        let ann = MKPointAnnotation()
        ann.coordinate = CLLocationCoordinate2D(latitude: Double(detailLatitude!)!, longitude: Double(detailLongitude!)!)
        ann.title = detailName!
        mapView.addAnnotation(ann)
        mapView.setCenter(ann.coordinate, animated: true)
        let region = MKCoordinateRegion(center: ann.coordinate, latitudinalMeters: 350, longitudinalMeters: 350)
        self.mapView.setRegion(region, animated: false)
    }
    
    func initSet(){
        if detailUrl == "" {
            safariButton.isHidden = true
        } else if detailUrl == nil {
            print("detailUrl = nil")
        } else {
            safariButton.isHidden = false
        }
        shopName.adjustsFontSizeToFitWidth = true
        shopName.text = detailName
        shopAddress.adjustsFontSizeToFitWidth = true
        shopAddress.text = detailAddress!
        
        socketLabel.adjustsFontSizeToFitWidth = true
        standingWorkLabel.adjustsFontSizeToFitWidth = true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return CafeAnnotationView(annotation: annotation as! MKAnnotation, reuseIdentifier: CafeAnnotationView.ReuseID)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailMapSegue" {
            let dmvc = segue.destination as! DetailMapViewController
            dmvc.shopName = detailName
            dmvc.latitude = Double(detailLatitude!)
            dmvc.longitude = Double(detailLongitude!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.hidesBarsOnSwipe = false
        
        viewContext = app?.persistentContainer.viewContext
        
        
        initSet()
        judgSet()
        cafeShopInMap()
        fetchRequestCafeList()
        judgeCoreDataHaveSave()
    }
}
