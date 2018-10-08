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
    
    var friendsInfoSorted: [Friend] = [
        Friend(id: 1, friend: "Winnie", avatar: "Winnie", avatarLikes: 1005),
        Friend(id: 2, friend: "Eeyore", avatar: "Eeyore", avatarLikes: 2005),
        Friend(id: 3, friend: "Piglet", avatar: "Piglet", avatarLikes: 3005),
        Friend(id: 4, friend: "Daddy", avatar: "Daddy", avatarLikes: 4005),
        Friend(id: 5, friend: "Win Unknown", avatar: "Unknown", avatarLikes: 5005)
    ].sorted(by: { $0.friend < $1.friend })
    
    let searchController = UISearchController()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filteredList: [Friend] =  []
    var searchText: String = ""
    
    var sections: [String] = []
    
    var valueSentFromSecondViewController:[String]?
    
    override func viewDidLoad() {
        sections = getSections()
        super.viewDidLoad()
        filteredList = friendsInfoSorted
        addSearch()
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = UITableViewAutomaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return getSections().count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let name = self.tableView(tableView, titleForHeaderInSection: section)
        return getElementsInSections(section: name!).count
        //return filteredList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.myFriendsCell.rawValue, for: indexPath) as! MyFriendsViewCell
        
        let headerTitle = self.tableView(tableView, titleForHeaderInSection: indexPath.section)
        
        let elements = getElementsInSections(section: headerTitle!)
        let friend = elements[indexPath.row]
        //let friend = filteredList[indexPath.row]
        
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
                let headerTitle = self.tableView(tableView, titleForHeaderInSection: indexPath.section)
                let elements = getElementsInSections(section: headerTitle!)
                let friend = elements[indexPath.row]
                profileVC.friend = friend
                //profileVC.friend = filteredList[indexPath.row]
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
            for element in friendsInfoSorted {
                if element.getFriendName().lowercased().contains(searchText.lowercased() ) {
                    filteredList.append(element)
                }
            }
        } else {
            filteredList = friendsInfoSorted
        }
        tableView.reloadData()
    }
    
    
    func getSections() -> [String]{
        var uniqueChar: [String] = []
        for element in filteredList {
            if !uniqueChar.contains(getFirstLetter(element.getFriendName())){
                uniqueChar.append(getFirstLetter(element.getFriendName()))
            }
        }
        return uniqueChar
    }
    
    func getElementsInSections(section: String) -> [Friend]{
        var res: [Friend] = []
        for element in filteredList {
            if getFirstLetter(element.getFriendName()).contains(section){
                res.append(element)
            }
        }
        return res
    }

    func getFirstLetter(_ text: String) -> String{
        return String(text.prefix(1))
    }
}
