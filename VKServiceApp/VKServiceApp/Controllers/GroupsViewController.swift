//
//  GroupsViewController.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 22/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit

class GroupsViewController: UITableViewController, UISearchBarDelegate {

    var groups: [Group] = [
        Group(group: "Winnie Fans", avatar: "Winnie", members: 1),
        Group(group: "Eeyore Fans", avatar: "Eeyore", members: 2),
        Group(group: "Piglet Fans", avatar: "Piglet", members: 3)
    ]
    
    var myGroups: [Group] = []
    
    override func viewDidLoad() {
        removeMyGroups()
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.allGroupCell.rawValue, for: indexPath) as! GroupsViewCell
        let group = groups[indexPath.row]
        cell.groupName.text = group.getGroupName()
        cell.groupAvatar.image = UIImage(named: group.getGroupAvatar())
        cell.groupMembers.text = group.getGroupMembers()
        return cell
    }

    func removeMyGroups(){
        for myGroup in myGroups {
            for i in (0..<groups.count).reversed(){
                if (groups[i].getGroupName() == myGroup.getGroupName()){
                    groups.remove(at: i)
                }
            }
        }
    }

}
