//
//  MyGroupsViewController.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 22/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit

class MyGroupsViewController: UITableViewController {

    var myGroups: [Group] = [
        Group(group: "Eeyore Fans", avatar: "Eeyore", members: 2)
    ]
    
    @IBAction func addGroup(segue: UIStoryboardSegue){
        guard let groupsListViewController = segue.source as? GroupsViewController else {
            return
        }
        if let indexPath = groupsListViewController.tableView.indexPathForSelectedRow{
            let newGroup = groupsListViewController.groups[indexPath.row]
            
            if !(isMyGroupsListContain(group: newGroup)){
                myGroups.append(newGroup)
                tableView.reloadData()
            }
        }
    }
    
    @IBAction func deleteGroup(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? MyGroupsViewCell else {
            return
        }
        if let index: Int = tableView.indexPath(for: cell)?.row {
            myGroups.remove(at: index)
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.myGroupCell.rawValue, for: indexPath) as! MyGroupsViewCell
        
        let group = myGroups[indexPath.row]
        cell.groupName.text = group.getGroupName()
        cell.groupAvatar.image = UIImage(named: group.getGroupAvatar())
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            myGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let profileVC = segue.destination as? GroupsViewController {
            profileVC.myGroups = self.myGroups
        }
    }
    
}
