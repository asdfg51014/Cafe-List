//
//  SaveTableViewController.swift
//  CafeNomad
//
//  Created by Albert on 2018/11/15.
//  Copyright © 2018 Albert.C. All rights reserved.
//

import UIKit
import CoreData

class SaveTableViewController: UITableViewController, NSFetchedResultsControllerDelegate{

    var cafeList: [CafeListMO] = []
    
    var fetchResultController: NSFetchedResultsController<CafeListMO>!
    
    @IBOutlet var emptyView: UIView!
    
    
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
    
    func settingNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = .lightGray
        navigationController?.navigationBar.tintColor = .brown
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.brown]
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.brown]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        if cafeList.count > 0 {
            tableView.backgroundView?.isHidden = true
        } else {
            tableView.backgroundView?.isHidden = false
        }
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
        
        return cafeList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SaveTableViewCell
        cell.shopName.text = cafeList[indexPath.row].name
        cell.shopAddress.text = cafeList[indexPath.row].address
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let cafeListToDelegate = self.fetchResultController.object(at: indexPath)
                context.delete(cafeListToDelegate)
                appDelegate.saveContext()
                print("Delete from SaveTableViewController")
            }
            completionHandler(true)
        }
        deleteAction.image = UIImage(named: "delete")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let sendSegue = segue.destination as! DetailViewController
                print(cafeList[indexPath.row].url)
                sendSegue.detailName = cafeList[indexPath.row].name
                sendSegue.detailAddress = cafeList[indexPath.row].address
                sendSegue.detailWifi = cafeList[indexPath.row].wifi
                sendSegue.detailSeat = cafeList[indexPath.row].seat
                sendSegue.detailQuite = cafeList[indexPath.row].quiet
                sendSegue.detailTasty = cafeList[indexPath.row].tasty
                sendSegue.detailMusic = cafeList[indexPath.row].music
                sendSegue.detailSocket = cafeList[indexPath.row].socket
                sendSegue.detailStandingDesk = cafeList[indexPath.row].standingWork
                sendSegue.detailLimitedTiime = cafeList[indexPath.row].limitedTime
                sendSegue.detailUrl = cafeList[indexPath.row].url
                sendSegue.detailLatitude = cafeList[indexPath.row].latitude
                sendSegue.detailLongitude = cafeList[indexPath.row].longitude
                
            }
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchObjects = controller.fetchedObjects {
            cafeList = fetchObjects as! [CafeListMO]
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRequestCafeList()
        settingNavigationBar()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundView = emptyView
        tableView.backgroundView?.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        print("Core Data: \(cafeList.count)")
    }
}
