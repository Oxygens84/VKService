//
//  GroupsViewController.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 22/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit

class GroupsViewController: UITableViewController, UISearchBarDelegate  {

    var groups: [Group] = [
        Group(id: 1, group: "Winnie Fans", avatar: "Winnie", members: 1),
        Group(id: 2, group: "Eeyore Fans", avatar: "Eeyore", members: 2),
        Group(id: 3, group: "Piglet Fans", avatar: "Piglet", members: 3)
    ]
    
    var myGroups: [Group] = []
    
    let searchController = UISearchController()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filteredList: [Group] =  []
    var searchText: String = ""
    
    override func viewDidLoad() {
        removeMyGroups()
        super.viewDidLoad()
        filteredList = groups
        addSearch()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.allGroupCell.rawValue, for: indexPath) as! GroupsViewCell
        let group = filteredList[indexPath.row]
        cell.groupName.text = group.getGroupName()
        cell.groupAvatar.image = UIImage(named: group.getGroupAvatar())
        cell.groupMembers.text = group.getGroupMembers()
        return cell
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
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
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
