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
    
    var starsImage = ["star1", "star2", "star3", "star4", "star5", "star6", "star7", "star8", "star9", "star10", "star11"]
    
    var number: Int?
    
    var cafeListMo: CafeListMO!
    
    var cafeList: [CafeListMO] = []
    
    var detail = [CafeAPI]()
    
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
        let url = URL(string: detail[0].url)
        let safariController = SFSafariViewController(url: url!)
        present(safariController, animated:  true, completion:  nil)
        print(detail[0].url)
    }
    
    @IBAction func shareButton(_ sender: UIBarButtonItem) {
        let activityVC: UIActivityViewController
        if detail[0].url != "" {
            activityVC = UIActivityViewController(activityItems: [detail[0].name, detail[0].address, detail[0].url], applicationActivities: nil)
        } else {
            activityVC = UIActivityViewController(activityItems: [detail[0].name, detail[0].address], applicationActivities: nil)
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
            if detail[0].name == adjustment.name {
                adjustmentSaveIsOn = true
                saveButton.setImage(UIImage(named: "checkOn"), for: .normal)
                break
            } else {
                adjustmentSaveIsOn = false
                saveButton.setImage(UIImage(named: "checkOff"), for: .normal)
            }
        }
        adjustmentSaveIsOn ? print("\(detail[0].name) has in CoreData.") : print("\(detail[0].name) hasn't in CoreData")
    }
    
    func judgeUserTapSaveButtonStatus(){
        print("Save button is working")
        reloadCafeList()
        if save == true {
            if cafeList.count == 0 {
                saveDetailToCoreData()
            } else {}
            for adjustment in cafeList {
                if detail[0].name != adjustment.name {
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
                    if detail[0].name == adjustment.name {
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
            cafeListMo.name = detail[0].name
            cafeListMo.address = detail[0].address
            cafeListMo.wifi = detail[0].wifi
            cafeListMo.seat = detail[0].seat
            cafeListMo.quiet = detail[0].quiet
            cafeListMo.tasty = detail[0].tasty
            cafeListMo.music = detail[0].music
            cafeListMo.limitedTime = detail[0].limited_time
            cafeListMo.socket = detail[0].socket
            cafeListMo.standingWork = detail[0].standing_desk
            cafeListMo.latitude = detail[0].latitude
            cafeListMo.longitude = detail[0].longitude
            cafeListMo.url = detail[0].url
            appDelegate.saveContext()
            print("Save \(detail[0].name)")
        }
    }
    
    func deleteDetailFormCoreData(){
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            for adjustment in cafeList {
                if adjustment.name == detail[0].name {
                    context.delete(adjustment)
                    appDelegate.saveContext()
                    print("Delete \(detail[0].name)")
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
        judge(p: wifiImage, n: detail[0].wifi)
        judge(p: seatImage, n: detail[0].seat)
        judge(p: quietImage, n: Double(detail[0].quiet))
        judge(p: tasty, n: Double(detail[0].tasty))
        judge(p: musicImage, n: Double(detail[0].music))
        judgeLimitLabel(detail[0].limited_time)
        judgeSocketLabel(detail[0].socket)
        judgeStandingWorkLabel(detail[0].standing_desk)
    }
    
    func cafeShopInMap(){
        let ann = MKPointAnnotation()
        ann.coordinate = CLLocationCoordinate2D(latitude: Double(detail[0].latitude)!, longitude: Double(detail[0].longitude)!)
        ann.title = detail[0].name
        mapView.addAnnotation(ann)
        mapView.setCenter(ann.coordinate, animated: true)
        let region = MKCoordinateRegion(center: ann.coordinate, latitudinalMeters: 350, longitudinalMeters: 350)
        self.mapView.setRegion(region, animated: false)
    }
    
    func initSet(){
        if detail[0].url == "" {
            safariButton.isHidden = true
        } else if detail[0].url == nil {
            print("detailUrl = nil")
        } else {
            safariButton.isHidden = false
        }
        shopName.adjustsFontSizeToFitWidth = true
        shopName.text = detail[0].name
        shopAddress.adjustsFontSizeToFitWidth = true
        shopAddress.text = detail[0].address
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
            dmvc.shopName = detail[0].name
            dmvc.latitude = Double(detail[0].latitude)
            dmvc.longitude = Double(detail[0].longitude)
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
