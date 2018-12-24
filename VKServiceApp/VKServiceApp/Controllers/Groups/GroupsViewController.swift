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
    let searchController = UISearchController()
    var searchText: String = ""
    let searchTextDefault: String = "Geek"
    
    var groups: [Group] = []
    var myGroups: [Group] = []
    var filteredList: [Group] = []

    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromVk(searchTextDefault)
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

}
