//
//  HomePageTableViewController.swift
//  CafeNomad
//
//  Created by Albert on 2018/11/18.
//  Copyright © 2018 Albert.C. All rights reserved.
//

import UIKit
import MapKit

class HomePageTableViewController: UITableViewController, UITabBarDelegate {

    var cafeShop: [CafeAPI] = []
    
    var cityName: String?
    
    var judfWifi: Bool?
    
    var judgSocket: Bool?
    
    var judeStandingTime: Bool?
    
    var judgLimited: Int?
    
    var sendcondition = false
    
    var resetCondition = false
    
    var pullTVC: UIRefreshControl!
    
    var search: UISearchController?
    
    let citys: [(e: String, c: String)] = [("Taipei", "臺北"), ("Keelung", "基隆"), ("Taoyuan", "桃園"), ("Hsinchu", "新竹"), ("Miaoli", "苗栗"), ("Taichung", "臺中"), ("Nantou", "南投"), ("Changhua", "彰化"), ("Yunlin", "雲林"), ("Chiayi", "嘉義"), ("Tainan", "臺南"), ("Kaohsiung", "高雄"), ("Pingtung", "屏東"), ("Yilan", "宜蘭"), ("Hualien", "花蓮"), ("Taitung", "臺東"), ("Penghu", "澎湖"), ("Lienchiang", "連江")]
    
    @IBOutlet var loadingView: UIView!
    @IBOutlet var emptyView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func backFromSearchPage(_ segue: UIStoryboardSegue){
        
    }
    
    @IBAction func resetAreaButton(_ sender: UIBarButtonItem) {
        showLoadingView()
        resetCondition = true
        getTaiwanCafeAPI()
    }
    
    
    //MARK: functions
    func settingNavigationBar() {
//        tableView.contentInsetAdjustmentBehavior = .never
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = UIColor(red: 194/255, green: 147/255, blue: 88/255, alpha: 1)
        navigationController?.navigationBar.backgroundColor = UIColor(red: 194/255, green: 147/255, blue: 88/255, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        navigationController?.navigationBar.isTranslucent = false
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func showLoadingView(){
        let tabBarHeight = tabBarController?.tabBar.frame.height
        let navigationBarHeight = navigationController?.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let minusHeight = tabBarHeight! + navigationBarHeight! + statusBarHeight
        loadingView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - minusHeight)
        loadingView.backgroundColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 0.3)
        //        loadingView.layer.zPosition = 2
        view.addSubview(loadingView)
        activityIndicator.startAnimating()
    }
    
    func hiddenLoadingView(){
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .preferredFramesPerSecond30, animations: {
            self.loadingView.alpha = 0
        }, completion: nil)
        activityIndicator.stopAnimating()
    }
    
    
    func get(){
        CallAPI.callApi(city: cityName!, call: {(theCall) in
            //            self.cafeShop = []
            DispatchQueue.main.async {
                //                self.hiddenLoadingView()
                self.cafeShop = theCall
                print("on recv \(self.cafeShop.count)")
                
                self.tableView.reloadData()
                if self.cafeShop.count == 0 {
                    self.tableView.backgroundView?.isHidden = false
                } else {
                    self.tableView.backgroundView?.isHidden = true
                }
            }
        })
    }
    
    
    
    func getTaiwanCafeAPI(){
        CallAPI2.callApi(call: {(theCall) in
            //            self.cafeShop = []
            DispatchQueue.main.async {
                
                self.cafeShop = theCall
                
                if self.resetCondition == false {
                    if let mapViewController = self.tabBarController?.viewControllers?[1] as? MapViewController {
                        mapViewController.points = []
                        mapViewController.points = theCall
                        
                        for point in theCall {
                            let ann = MKPointAnnotation()
                            ann.coordinate = CLLocationCoordinate2DMake(Double(point.latitude)!, Double(point.longitude)!)
                            ann.title = point.name
                            mapViewController.mapView.addAnnotation(ann)
                        }
                        self.resetCondition = false
                    }
                }
                self.hiddenLoadingView()
                //                self.tabBarController?.viewControllers![1].view
                self.tableView.reloadData()
                if self.cafeShop.count == 0 {
                    self.tableView.backgroundView?.isHidden = false
                } else {
                    self.tableView.backgroundView?.isHidden = true
                }
            }
        })
    }
    
    func get3(){
        print("get from filter")
        CallAPI.callApi(city: cityName!, call: {(theCall) in
            //            self.cafeShop = []
            DispatchQueue.main.async {
                self.cafeShop = theCall
                if self.judfWifi == false {
                    self.cafeShop = self.cafeShop.filter({$0.wifi == 0})
                } else {
                    self.cafeShop = self.cafeShop.filter({$0.wifi != 0})
                }
                print(self.cafeShop.count)
                if self.judgSocket == false {
                    self.cafeShop = self.cafeShop.filter({$0.socket == "no"})
                } else {
                    self.cafeShop = self.cafeShop.filter({$0.socket == "yes"})
                }
                print(self.cafeShop.count)
                if self.judeStandingTime == false {
                    self.cafeShop = self.cafeShop.filter({$0.standing_desk == "no"})
                } else {
                    self.cafeShop = self.cafeShop.filter({$0.standing_desk == "yes"})
                }
                print(self.cafeShop.count)
                if self.judgLimited == 0 {
                    self.cafeShop = self.cafeShop.filter({$0.limited_time == "no"})
                } else if self.judgLimited == 2 {
                    self.cafeShop = self.cafeShop.filter({$0.limited_time == "yes"})
                }
                self.cityName = ""
                self.sendcondition = false
                self.judfWifi = false
                self.judgSocket = false
                self.judeStandingTime = false
                self.judgLimited = 1
                
                self.tableView.reloadData()
                if self.cafeShop.count == 0 {
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
            } else if judfWifi == true {
                filter()
            } else if judgSocket == true {
                filter()
            } else if judeStandingTime == true {
                filter()
            } else if judgLimited != 1 {
                filter()
            }
            
        }
        
    }
    
    func filter() {
        get3()
    }
    
    func settingSearchController() {
        search = UISearchController(searchResultsController: nil)
        //        navigationItem.searchController = search
        tableView.tableHeaderView = search?.searchBar
        
        search?.searchBar.barTintColor = .clear
        //        search?.searchBar.backgroundImage = UIImage()
        search?.searchBar.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        search?.searchBar.searchBarStyle = .default
        //        search?.searchBar.
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cafeShop.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HomePageTableViewCell
        cell.shopNameLabel.text = cafeShop[indexPath.row].name
        cell.shopAddressLabel.text = cafeShop[indexPath.row].address
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    //MRAK: Animate
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: {
            cell.alpha = 1
        }, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let sendSegue = segue.destination as! DetailViewController
                
                sendSegue.detailName = cafeShop[indexPath.row].name
                sendSegue.detailAddress = cafeShop[indexPath.row].address
                sendSegue.detailWifi = cafeShop[indexPath.row].wifi
                sendSegue.detailSeat = cafeShop[indexPath.row].seat
                sendSegue.detailQuite = cafeShop[indexPath.row].quiet
                sendSegue.detailTasty = cafeShop[indexPath.row].tasty
                sendSegue.detailMusic = cafeShop[indexPath.row].music
                sendSegue.detailSocket = cafeShop[indexPath.row].socket
                sendSegue.detailStandingDesk = cafeShop[indexPath.row].standing_desk
                sendSegue.detailLimitedTiime = cafeShop[indexPath.row].limited_time
                sendSegue.detailUrl = cafeShop[indexPath.row].url
                sendSegue.detailLatitude = cafeShop[indexPath.row].latitude
                sendSegue.detailLongitude = cafeShop[indexPath.row].longitude
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingSearchController()
        settingNavigationBar()
//        showLoadingView()
//        getTaiwanCafeAPI()
        self.tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
//        tabBarController?.viewControllers![1].view
//        tableView.backgroundView = emptyView
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        judgCondition()
        
    }
    
    
}
