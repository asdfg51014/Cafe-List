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

class HomePageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    var cafeShop: [CafeAPI] = []
    
    var searchResult: [CafeAPI] = []
    
    var cityName: String?
    
    var judfWifi: Int?
    
    var judgSocket: Int?
    
    var judeStandingWork: Int?
    
    var judgLimited: Int?
    
    var sendcondition = false
    
    var resetCondition = false
    
    var pullTVC: UIRefreshControl!
    
    var search: UISearchController?
    
    let citys: [(e: String, c: String)] = [("Taipei", "臺北"), ("Keelung", "基隆"), ("Taoyuan", "桃園"), ("Hsinchu", "新竹"), ("Miaoli", "苗栗"), ("Taichung", "臺中"), ("Nantou", "南投"), ("Changhua", "彰化"), ("Yunlin", "雲林"), ("Chiayi", "嘉義"), ("Tainan", "臺南"), ("Kaohsiung", "高雄"), ("Pingtung", "屏東"), ("Yilan", "宜蘭"), ("Hualien", "花蓮"), ("Taitung", "臺東"), ("Penghu", "澎湖"), ("Lienchiang", "連江")]
    
    @IBOutlet var tableView: UITableView!
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
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = UIColor.lightGray
        navigationController?.navigationBar.tintColor = .brown
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.brown]
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.brown]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.hidesBarsOnSwipe = false
    }
    
    func showLoadingView(){
        let tabBarHeight = tabBarController?.tabBar.frame.height
        let navigationBarHeight = navigationController?.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let minusHeight = tabBarHeight! + navigationBarHeight! + statusBarHeight
        loadingView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
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
        
        CallAPI.callApi(city: cityName!, call: {(theCall) in
//            self.cafeShop = []
            DispatchQueue.main.async {
                self.cafeShop = theCall
                
                
                if self.judfWifi == 0 {
                    self.cafeShop = self.cafeShop.filter({$0.wifi != 0})
                } else if self.judfWifi == 2 {
                    self.cafeShop = self.cafeShop.filter({$0.wifi == 0})
                }
                
                if self.judgSocket == 0 {
                    self.cafeShop = self.cafeShop.filter({$0.socket == "yes"})
                } else if self.judgSocket == 2 {
                    self.cafeShop = self.cafeShop.filter({$0.socket == "no"})
                }
                
                if self.judeStandingWork == 0 {
                    self.cafeShop = self.cafeShop.filter({$0.standing_desk == "yes"})
                } else if self.judeStandingWork == 1 {
                    self.cafeShop = self.cafeShop.filter({$0.standing_desk == "no"})
                }
                
                if self.judgLimited == 0 {
                    self.cafeShop = self.cafeShop.filter({$0.limited_time == "no"})
                } else if self.judgLimited == 2 {
                    self.cafeShop = self.cafeShop.filter({$0.limited_time == "yes"})
                }
                self.cityName = ""
                self.sendcondition = false
                self.judfWifi = 1
                self.judgSocket = 1
                self.judeStandingWork = 1
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
        get3()
    }
    
    func settingSearchController() {
        search = UISearchController(searchResultsController: nil)
        search?.searchBar.autocapitalizationType = .none
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = search
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = search?.searchBar
        }
        search?.delegate = self
        search?.searchResultsUpdater = self
        search?.dimsBackgroundDuringPresentation = false
        search?.searchBar.barTintColor = .white
        search?.searchBar.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        search?.searchBar.searchBarStyle = .default
        search?.searchBar.placeholder = "搜尋店名、地址"
        definesPresentationContext = true
    }
    
    func filterContent(for searchText: String) {
        searchResult = cafeShop.filter({ (results) -> Bool in
            let name = results.name, address = results.address
            let isMach = name.localizedCaseInsensitiveContains(searchText) || address.localizedCaseInsensitiveContains(searchText)
            return isMach
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (search?.isActive)! {
            return searchResult.count
        } else {
            return cafeShop.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HomePageTableViewCell
        let searchs = ((search?.isActive)!) ? searchResult[indexPath.row] : cafeShop[indexPath.row]
        cell.shopNameLabel.text = searchs.name
        cell.shopAddressLabel.text = searchs.address
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
   
    
    //MRAK: Animate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: {
            cell.alpha = 1
        }, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let sendSegue = segue.destination as! DetailViewController
                
                sendSegue.detailName = ((search?.isActive)!) ? searchResult[indexPath.row].name : cafeShop[indexPath.row].name
                sendSegue.detailAddress = ((search?.isActive)!) ? searchResult[indexPath.row].address : cafeShop[indexPath.row].address
                sendSegue.detailWifi = ((search?.isActive)!) ? searchResult[indexPath.row].wifi : cafeShop[indexPath.row].wifi
                sendSegue.detailSeat = ((search?.isActive)!) ? searchResult[indexPath.row].seat : cafeShop[indexPath.row].seat
                sendSegue.detailQuite = ((search?.isActive)!) ? searchResult[indexPath.row].quiet : cafeShop[indexPath.row].quiet
                sendSegue.detailTasty = ((search?.isActive)!) ? searchResult[indexPath.row].tasty : cafeShop[indexPath.row].tasty
                sendSegue.detailMusic = ((search?.isActive)!) ? searchResult[indexPath.row].music : cafeShop[indexPath.row].music
                sendSegue.detailSocket = ((search?.isActive)!) ? searchResult[indexPath.row].name : cafeShop[indexPath.row].socket
                sendSegue.detailStandingDesk = ((search?.isActive)!) ? searchResult[indexPath.row].standing_desk : cafeShop[indexPath.row].standing_desk
                sendSegue.detailLimitedTiime = ((search?.isActive)!) ? searchResult[indexPath.row].limited_time : cafeShop[indexPath.row].limited_time
                sendSegue.detailUrl = ((search?.isActive)!) ? searchResult[indexPath.row].url : cafeShop[indexPath.row].url
                sendSegue.detailLatitude = ((search?.isActive)!) ? searchResult[indexPath.row].latitude : cafeShop[indexPath.row].latitude
                sendSegue.detailLongitude = ((search?.isActive)!) ? searchResult[indexPath.row].longitude : cafeShop[indexPath.row].longitude
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingSearchController()
        settingNavigationBar()
        showLoadingView()
        getTaiwanCafeAPI()
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
