//
//  MyGroupExtensionController.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 25/12/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseDatabase

extension MyGroupsViewController {
    
    func loadDataFromVk(){
        service.loadMyGroupDataWithAlamofire() { (myGroups, error) in
            if let error = error {
                print(error)
            }
            if let myGroups = myGroups {
                self.myGroups = myGroups.sorted(by: { $0.group < $1.group })
                self.filteredList = myGroups.sorted(by: { $0.group < $1.group })
            }
        }
        self.tableView?.reloadData()
    }
    
    func loadDataFromRealm(){
        let groups = service.loadFromRealm() as [Group]
        self.myGroups = groups
        self.filteredList = groups.sorted(by: { $0.group < $1.group })
        if self.myGroups.count == 0 {
            loadDataFromVk()
        }
        self.tableView?.reloadData()
    }
    
    func observeMyGroups(){
        let data = realm.objects(Group.self)
        notificationToken = data.observe { (changes) in
            switch changes {
            case .initial(let results):
                print(results)
                self.loadDataFromRealm()
            case .update(let results):
                print(results)
                self.loadDataFromRealm()
            case .error(let error):
                print(error)
            }
        }
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
                addedGroups.append(group.getGroupId())
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
    
    
    func addSearch(){
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        filterList()
        self.tableView?.reloadData()
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

