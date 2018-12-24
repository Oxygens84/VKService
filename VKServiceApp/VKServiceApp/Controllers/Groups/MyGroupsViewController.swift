//
//  MyGroupsViewController.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 22/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseDatabase

class MyGroupsViewController: UITableViewController, UISearchBarDelegate  {
    
    var myGroups: [Group] = []
    var addedGroups: [Int] = []
    
    var users = [FirebaseUser]()
    let ref = Database.database().reference(withPath: "users")
    let realm = try! Realm()
    var notificationToken: NotificationToken?
    
    let service = GroupService()
    var refresher: UIRefreshControl!
    let searchController = UISearchController()
    var filteredList: [Group] =  []
    var searchText: String = ""
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        observeMyGroups()
        
//        ref.observe(DataEventType.value) {snapshot in
//            var users: [FirebaseUser] = []
//            for child in snapshot.children {
//                if let child = child as? DataSnapshot,
//                    let user = FirebaseUser(snapShot: child) {
//                    users.append(user)
//                }
//            }
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSearch()
        addRefresher()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        notificationToken?.invalidate()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.myGroupCell.rawValue, for: indexPath) as! MyGroupsViewCell

        let group = filteredList[indexPath.row]
        cell.configure(group: group)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            if let index: Int = indexPath.row {
                for i in (0..<myGroups.count).reversed() {
                    if filteredList[index].getGroupId() == myGroups[i].getGroupId() {
                       service.deleteData(myGroups[i])
                       myGroups.remove(at: i)
                       break
                    }
                }
            }
            filterList()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let profileVC = segue.destination as? GroupsViewController {
            profileVC.myGroups = self.myGroups
        }
    }

}