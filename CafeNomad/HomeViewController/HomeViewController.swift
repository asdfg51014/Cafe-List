//
//  HomePageViewController.swift
//  CafeNomad
//
//  Created by Albert on 2018/11/1.
//  Copyright © 2018 Albert.C. All rights reserved.
//

import UIKit
import MapKit
import CoreData


class HomeViewController: UIViewController, UITabBarDelegate {
    
    var cafeShopArray: [CafeAPI] = []
    var searchResultArray: [CafeAPI] = []
    let fullScreenSize = UIScreen.main.bounds
    var cityName: String?
    var judfWifi: Int?
    var judgSocket: Int?
    var judeStandingWork: Int?
    var judgLimited: Int?
    var sendcondition = false
    var resetCondition = false
    var pullTVC: UIRefreshControl!
    var search: UISearchController?
    let citysArray: [(e: String, c: String)] = [("Taipei", "臺北"), ("Keelung", "基隆"), ("Taoyuan", "桃園"), ("Hsinchu", "新竹"), ("Miaoli", "苗栗"), ("Taichung", "臺中"), ("Nantou", "南投"), ("Changhua", "彰化"), ("Yunlin", "雲林"), ("Chiayi", "嘉義"), ("Tainan", "臺南"), ("Kaohsiung", "高雄"), ("Pingtung", "屏東"), ("Yilan", "宜蘭"), ("Hualien", "花蓮"), ("Taitung", "臺東"), ("Penghu", "澎湖"), ("Lienchiang", "連江")]
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var loadingView: UIView!
    @IBOutlet var emptyView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    @IBAction func backFromSearchPage(_ segue: UIStoryboardSegue){
        
    }
    
    @IBAction func resetAreaButton(_ sender: UIBarButtonItem) {
        resetCondition = true
    }
    
    //MARK: functions
    func getData(){
        GetData.getData { (callBack) in
            DispatchQueue.main.async {
                self.cafeShopArray = callBack
                self.tableView.reloadData()
                HomeViewControllerFunctionsFile.hideLoadingView(loadingView: self.loadingView)
                self.cafeShopArray.count == 0 ?  (self.tableView.backgroundView?.isHidden = false) : (self.tableView.backgroundView?.isHidden = true)
                if let mapViewController = self.tabBarController?.viewControllers?[1] as? MapViewController {
                    let pointAnnotation = MKPointAnnotation()
                    callBack.forEach({ (points) in
                        pointAnnotation.coordinate = CLLocationCoordinate2DMake(Double(points.latitude)!, Double(points.longitude)!)
                        pointAnnotation.title = points.name
                        mapViewController.mapView.addAnnotation(pointAnnotation)
                    })
                }
            }
        }
    }
    
    // recive response and filter
    func receiveAndFilter(){
        CallAPI.callApi(city: cityName!, call: {(theCall) in
            DispatchQueue.main.async {
                self.cafeShopArray = theCall
                if self.judfWifi == 0 {
                    self.cafeShopArray = self.cafeShopArray.filter({$0.wifi != 0})
                } else if self.judfWifi == 2 {
                    self.cafeShopArray = self.cafeShopArray.filter({$0.wifi == 0})
                }
                
                if self.judgSocket == 0 {
                    self.cafeShopArray = self.cafeShopArray.filter({$0.socket == "yes"})
                } else if self.judgSocket == 2 {
                    self.cafeShopArray = self.cafeShopArray.filter({$0.socket == "no"})
                }
                
                if self.judeStandingWork == 0 {
                    self.cafeShopArray = self.cafeShopArray.filter({$0.standing_desk == "yes"})
                } else if self.judeStandingWork == 1 {
                    self.cafeShopArray = self.cafeShopArray.filter({$0.standing_desk == "no"})
                }
                
                if self.judgLimited == 0 {
                    self.cafeShopArray = self.cafeShopArray.filter({$0.limited_time == "no"})
                } else if self.judgLimited == 2 {
                    self.cafeShopArray = self.cafeShopArray.filter({$0.limited_time == "yes"})
                }
                self.cityName = ""
                self.sendcondition = false
                self.judfWifi = 1
                self.judgSocket = 1
                self.judeStandingWork = 1
                self.judgLimited = 1
                
                self.tableView.reloadData()
                if self.cafeShopArray.count == 0 {
                    self.tableView.backgroundView?.isHidden = false
                } else {
                    self.tableView.backgroundView?.isHidden = true
                }
            }
        })
    }
    
    func judgCondition(){
        if sendcondition == true {
            if cityName != "" {
                filter()
            } else if judfWifi != 1 {
                filter()
            } else if judgSocket != 1 {
                filter()
            } else if judeStandingWork != 1 {
                filter()
            } else if judgLimited != 1 {
                filter()
            }
        }

    }
    
    func filter() {
        receiveAndFilter()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let sendSegue = segue.destination as! DetailViewController
                
                sendSegue.detail = [((search?.isActive)!) ? searchResultArray[indexPath.row] : cafeShopArray[indexPath.row]]
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingSearchController()
        HomeViewControllerFunctionsFile.showLoadingView(tabBarHeight: (tabBarController?.tabBar.frame.height)!, navigationBarHeight: (navigationController?.navigationBar.frame.height)!, fullScreenSize: fullScreenSize, loadingView: loadingView, superView: self.view)
        getData()
        self.tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tabBarController?.viewControllers![1].loadViewIfNeeded()
        tableView.backgroundView = emptyView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        judgCondition()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough") {
            return
        }
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let walkthroughViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthoughViewController {
            present(walkthroughViewController, animated: true, completion: nil)
        }
    }
    
    
    
    
}
