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
    
    var cafeShopArray: [CafeAPI] = []
    var searchResultArray: [CafeAPI] = []
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
        showLoadingView()
        resetCondition = true
        receiveTaiwanCafeResponse()
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
            DispatchQueue.main.async {
                self.cafeShopArray = theCall
                self.tableView.reloadData()
                if self.cafeShopArray.count == 0 {
                    self.tableView.backgroundView?.isHidden = false
                } else {
                    self.tableView.backgroundView?.isHidden = true
                }
            }
        })
    }
    
    func receiveTaiwanCafeResponse(){
        CallAPI2.callApi(call: {(theCall) in
            DispatchQueue.main.async {
                self.cafeShopArray = theCall
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
                self.tableView.reloadData()
                if self.cafeShopArray.count == 0 {
                    self.tableView.backgroundView?.isHidden = false
                } else {
                    self.tableView.backgroundView?.isHidden = true
                }
            }
        })
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
        searchResultArray = cafeShopArray.filter({ (results) -> Bool in
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
            return searchResultArray.count
        } else {
            return cafeShopArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HomePageTableViewCell
        let searchs = ((search?.isActive)!) ? searchResultArray[indexPath.row] : cafeShopArray[indexPath.row]
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
                
                sendSegue.detailName = ((search?.isActive)!) ? searchResultArray[indexPath.row].name : cafeShopArray[indexPath.row].name
                sendSegue.detailAddress = ((search?.isActive)!) ? searchResultArray[indexPath.row].address : cafeShopArray[indexPath.row].address
                sendSegue.detailWifi = ((search?.isActive)!) ? searchResultArray[indexPath.row].wifi : cafeShopArray[indexPath.row].wifi
                sendSegue.detailSeat = ((search?.isActive)!) ? searchResultArray[indexPath.row].seat : cafeShopArray[indexPath.row].seat
                sendSegue.detailQuite = ((search?.isActive)!) ? searchResultArray[indexPath.row].quiet : cafeShopArray[indexPath.row].quiet
                sendSegue.detailTasty = ((search?.isActive)!) ? searchResultArray[indexPath.row].tasty : cafeShopArray[indexPath.row].tasty
                sendSegue.detailMusic = ((search?.isActive)!) ? searchResultArray[indexPath.row].music : cafeShopArray[indexPath.row].music
                sendSegue.detailSocket = ((search?.isActive)!) ? searchResultArray[indexPath.row].name : cafeShopArray[indexPath.row].socket
                sendSegue.detailStandingDesk = ((search?.isActive)!) ? searchResultArray[indexPath.row].standing_desk : cafeShopArray[indexPath.row].standing_desk
                sendSegue.detailLimitedTiime = ((search?.isActive)!) ? searchResultArray[indexPath.row].limited_time : cafeShopArray[indexPath.row].limited_time
                sendSegue.detailUrl = ((search?.isActive)!) ? searchResultArray[indexPath.row].url : cafeShopArray[indexPath.row].url
                sendSegue.detailLatitude = ((search?.isActive)!) ? searchResultArray[indexPath.row].latitude : cafeShopArray[indexPath.row].latitude
                sendSegue.detailLongitude = ((search?.isActive)!) ? searchResultArray[indexPath.row].longitude : cafeShopArray[indexPath.row].longitude
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingSearchController()
        settingNavigationBar()
        showLoadingView()
        receiveTaiwanCafeResponse()
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
