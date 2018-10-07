//
//  MyFriendsViewController.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 22/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit

class MyFriendsViewController: UITableViewController, UISearchBarDelegate {

    var friendsInfo: [Friend] = [
        Friend(friend: "Winnie", avatar: "Winnie", avatarLikes: 1005),
        Friend(friend: "Eeyore", avatar: "Eeyore", avatarLikes: 2005),
        Friend(friend: "Piglet", avatar: "Piglet", avatarLikes: 3005),
        Friend(friend: "Daddy", avatar: "Daddy", avatarLikes: 4005),
        Friend(friend: "Unknown", avatar: "Unknown", avatarLikes: 5005)
    ]
    
    let searchController = UISearchController()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filteredList: [Friend] =  []
    var searchText: String = ""
    
    var valueSentFromSecondViewController:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredList = friendsInfo
        addSearch()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.myFriendsCell.rawValue, for: indexPath) as! MyFriendsViewCell
        let friend = filteredList[indexPath.row]
        cell.friendName.text = friend.getFriendName()
        cell.friendAvatar.image = UIImage(named: friend.getFriendAvatar())
        return cell
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

}
