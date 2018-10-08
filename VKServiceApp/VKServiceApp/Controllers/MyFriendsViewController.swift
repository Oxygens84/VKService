//
//  MyFriendsViewController.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 22/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit

class MyFriendsViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var table: UITableView!
    
    var friendsInfo: [Friend] = [
        Friend(friend: "Winnie", avatar: "Winnie", avatarLikes: 1005),
        Friend(friend: "Eeyore", avatar: "Eeyore", avatarLikes: 2005),
        Friend(friend: "Piglet", avatar: "Piglet", avatarLikes: 3005),
        Friend(friend: "Daddy", avatar: "Daddy", avatarLikes: 4005),
        Friend(friend: "Winnie False", avatar: "Winnie", avatarLikes: 1005),
        Friend(friend: "Unknown", avatar: "Unknown", avatarLikes: 5005)
    ]
    
    let searchController = UISearchController()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filteredList: [Friend] =  []
    var searchText: String = ""
    
    var sections: [String] = []
    
    var valueSentFromSecondViewController:[String]?
    
    override func viewDidLoad() {
        sections = getSections()
        super.viewDidLoad()
        filteredList = friendsInfo
        addSearch()
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = UITableViewAutomaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return getSections().count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.myFriendsCell.rawValue, for: indexPath) as! MyFriendsViewCell
        
        let friend = filteredList[indexPath.row]
        let headerTitle = self.tableView(tableView, titleForHeaderInSection: indexPath.section)
        
        cell.friendName.text = friend.getFriendName()
        cell.friendAvatar.image = UIImage(named: friend.getFriendAvatar())
        
        if !getFirstLetter(friend.getFriendName()).contains(headerTitle!) {
            cell.isHidden = true
        } else {
            cell.isHidden = false
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let isHidden = super.tableView.cellForRow(at: indexPath)?.isHidden, isHidden {
            print(isHidden)
            return 0.0
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let firstLetter = filteredList[section].getFriendName().prefix(1)
        return String(firstLetter)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let profileVC = segue.destination as? FriendInfoViewController {
            if let indexPath = tableView.indexPathForSelectedRow{
                profileVC.friend =  filteredList[indexPath.row]
            }
        }
    }
    
    
    func addSearch(){
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        if searchText != "" {
            filteredList.removeAll()
            for element in friendsInfo {
                if element.getFriendName().lowercased().contains(searchText.lowercased() ) {
                    filteredList.append(element)
                }
            }
        } else {
            filteredList = friendsInfo
        }
        tableView.reloadData()
    }
    
    
    func getSections() -> [String]{
        var uniqueChar: [String] = []
        for element in filteredList {
            uniqueChar.append(getFirstLetter(element.getFriendName()))
        }
        return uniqueChar
    }

    func getFirstLetter(_ text: String) -> String{
        return String(text.prefix(1))
    }
}
