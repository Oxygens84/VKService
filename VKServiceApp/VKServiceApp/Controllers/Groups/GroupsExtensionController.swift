//
//  GroupsExtensionController.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 25/12/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit
import RealmSwift

extension GroupsViewController {
    
    func loadDataFromVk(_ searchText: String) {
        service.loadGroupDataWithAlamofire(searchText: searchText) { (groups, error) in
            if let error = error {
                print(error)
            }
            if let groups = groups {
                self.groups = groups
                self.filteredList = groups
            }
        }
        self.tableView?.reloadData()
    }
    
    func removeMyGroups(){
        for myGroup in myGroups {
            for i in (0..<groups.count).reversed(){
                if (groups[i].getGroupId() == myGroup.getGroupId()){
                    groups.remove(at: i)
                }
            }
        }
    }

    
    func addSearch(){
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.text = self.searchText
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        loadDataFromVk(searchText)
        filterList()
        tableView.reloadData()
    }
    
    func filterList(){
        if searchText != "" {
            filteredList.removeAll()
            for element in groups {
                if element.getGroupName().lowercased().contains(searchText.lowercased() ) {
                    filteredList.append(element)
                }
            }
        } else {
            filteredList = groups
        }
    }
    
}
