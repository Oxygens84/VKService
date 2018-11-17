//
//  MyGroupsViewController.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 22/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit
import RealmSwift

class MyGroupsViewController: UITableViewController, UISearchBarDelegate  {

    let service = GroupService()
    var refresher: UIRefreshControl!
    var myGroups: [Group] = []
    
    let searchController = UISearchController()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filteredList: [Group] =  []
    var searchText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSearch()
        //loadDataFromRealm()
        loadDataFromVk()
        addRefresher()
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



extension MyGroupsViewController {
    
    func loadDataFromVk(){
        service.loadMyGroupDataWithAlamofire() { (myGroups, error) in
            if let error = error {
                print(error)
            }
            if let myGroups = myGroups {
                self.myGroups = myGroups
                self.filteredList = myGroups
                self.tableView?.reloadData()
            }
        }
    }
    
    func loadDataFromRealm(){
        self.myGroups = service.loadGroupsFromRealm()
        if self.myGroups.count == 0 {
            loadDataFromVk()
        }
        self.tableView?.reloadData()
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue){
        guard let groupsListViewController = segue.source as? GroupsViewController else {
            return
        }
        
        if let indexPath = groupsListViewController.tableView.indexPathForSelectedRow{
            let group = groupsListViewController.filteredList[indexPath.row]
            if !(isMyGroupsListContain(group: group)){
                var element: [Group] = []
                element.append(group)
                myGroups.append(element[0])
                filterList()
                service.saveData(element)
            } else {
                let alertController = UIAlertController(title: "Warning!", message: "You are already in the group \(group.getGroupName())", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "OK", style: .default){ (action) in
                    print("Error 1. Action forbidden [Group is already in the list]")
                }
                alertController.addAction(confirmAction)
                present(alertController, animated: true, completion: nil)
            }
            tableView.reloadData()
        }
    }
    
    @IBAction func deleteGroup(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? MyGroupsViewCell else {
            return
        }
        if let index: Int = tableView.indexPath(for: cell)?.row {
            for i in (0..<myGroups.count).reversed() {
                if filteredList[index].getGroupId() == myGroups[i].getGroupId() {
                    service.deleteData(myGroups[i])
                    myGroups.remove(at: i)
                    break                    
                }
            }
            filterList()
            tableView.reloadData()
        }
    }
    
    func isMyGroupsListContain(group: Group) -> Bool{
        for myGroup in myGroups {
            if myGroup.getGroupName() == group.getGroupName(){
                return true
            }
        }
        return false
    }
    
    func filterList(){
        if searchText != "" {
            filteredList.removeAll()
            for element in myGroups {
                if element.getGroupName().lowercased().contains(searchText.lowercased() ) {
                    filteredList.append(element)
                }
            }
        } else {
            filteredList = myGroups
        }
    }
    
}


extension MyGroupsViewController {
    
    func addSearch(){
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        filterList()
        tableView.reloadData()
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        loadDataFromVk()
    }
    
    @objc func handlerRefresh(){
        loadDataFromVk()
        refresher.endRefreshing()
    }
    
    func addRefresher(){
        refresher = UIRefreshControl()
        tableView.addSubview(refresher)
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.tintColor = UIColor.purple
        refresher.addTarget(self, action: #selector(handlerRefresh), for: .valueChanged)
    }
    
}
