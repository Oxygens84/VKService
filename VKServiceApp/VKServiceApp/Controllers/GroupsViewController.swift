//
//  GroupsViewController.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 22/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit

class GroupsViewController: UITableViewController, UISearchBarDelegate  {

    let service = GroupService()
    
    var groups: [Group] = []
    var myGroups: [Group] = []
    
    let searchController = UISearchController()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filteredList: [Group] =  []
    var searchText: String = ""
    let searchTextDefault: String = "Geek"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(searchTextDefault)
        addSearch()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.allGroupCell.rawValue, for: indexPath) as! GroupsViewCell
        let group = filteredList[indexPath.row]
        cell.configure(group: group)
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
        searchBar.text = self.searchText
    }
    
    func loadData(_ searchText: String) {
        service.loadGroupDataWithAlamofire(searchText: searchText) { (groups, error) in
            if let error = error {
                print(error)
            }
            if let groups = groups {
                self.groups = groups
                self.removeMyGroups()
                self.filteredList = groups
                self.tableView?.reloadData()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        loadData(searchText)
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
