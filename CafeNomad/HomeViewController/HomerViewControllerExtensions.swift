//
//  HomerViewControllerExtensions.swift
//  CafeNomad
//
//  Created by Albert on 2019/1/20.
//  Copyright © 2019 Albert.C. All rights reserved.
//

import Foundation
import UIKit

extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    
    //MARK: TableView Functions
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
    
}

extension HomeViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    
    //MARK: Search Bar Funcations
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
}
