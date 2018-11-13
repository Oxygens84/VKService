//
//  MyFriendsViewController.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 22/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit
import RealmSwift

class MyFriendsViewController: UITableViewController, UISearchBarDelegate, UINavigationControllerDelegate
{

    let interactiveTransition = CustomInteractiveTransition()
    let service = FriendService()
    
    var filteredList: [Friend] =  []
    var friendsInfoSorted: [Friend] = []
    
    var sections: [String] = []
    var usedSection: [String] = []
    var valueSentFromSecondViewController:[String]?
    
    let searchController = UISearchController()
    var searchText: String = ""
    var refresher: UIRefreshControl!
    

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadDataFromRealm()
        loadDataFromVk()
        
        addSearch()
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = UITableView.automaticDimension
        self.navigationController?.delegate = self
        addRefresher()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return filteredList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let name = self.tableView(tableView, titleForHeaderInSection: section)
        if !usedSection.contains(name!) {
            usedSection.append(name!)
            return getElementsInSections(section: name!).count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.myFriendsCell.rawValue, for: indexPath) as! MyFriendsViewCell

        let headerTitle = self.tableView(tableView, titleForHeaderInSection: indexPath.section)
        let elements = getElementsInSections(section: headerTitle!)
        let element = elements[indexPath.row]
        cell.configure(friend: element)

        if getFirstLetter(element.friend).contains(headerTitle!) {
            cell.isHidden = false
        } else {
            cell.isHidden = true
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let isHidden = super.tableView.cellForRow(at: indexPath)?.isHidden, isHidden {
            print(isHidden)
            return 0.0
        }
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let firstLetter = filteredList[section].friend.prefix(1)
        return String(firstLetter)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let name = self.tableView(tableView, titleForHeaderInSection: section)
        if !usedSection.contains(name!) {
            return 20.0
        } else {
            return 0
        }
    }

    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            if operation == .push {
                self.interactiveTransition.viewController = toVC
                return Animator()
            } else if operation == .pop {
                if navigationController.viewControllers.first != toVC {
                    self.interactiveTransition.viewController = toVC
                }
                return AnimatorBack()
            }
            return nil
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let profileVC = segue.destination as? FriendInfoViewController {
            if let indexPath = tableView.indexPathForSelectedRow{
                let headerTitle = self.tableView(tableView, titleForHeaderInSection: indexPath.section)
                let elements = getElementsInSections(section: headerTitle!)
                let friend = elements[indexPath.row]
                profileVC.friend = friend
            }
        }
    }


    func getFirstLetter(_ text: String) -> String{
        return String(text.prefix(1))
    }
    
    func getSections() -> [String]{
        var uniqueChar: [String] = []
        for element in filteredList {
            if !uniqueChar.contains(getFirstLetter(element.friend)){
                uniqueChar.append(getFirstLetter(element.friend))
            }
        }
        return uniqueChar.sorted()
    }

    func getElementsInSections(section: String) -> [Friend]{
        var res: [Friend] = []
        for element in filteredList {
            if getFirstLetter(element.friend).contains(section){
                res.append(element)
            }
        }
        return res
    }


}

extension MyFriendsViewController {
    
    func loadDataFromVk(){
        service.loadFriendDataWithAlamofire() { (friends, error) in
            if let error = error {
                print(error)
            }
            if let friends = friends?.sorted(by: { $0.friend < $1.friend }) {
                self.friendsInfoSorted = friends
                self.filteredList = friends
                self.tableView?.reloadData()
            }
        }
    }
    
    func loadDataFromRealm(){
        let friends = service.loadFriendsFromRealm().sorted(by: { $0.friend < $1.friend })
        self.friendsInfoSorted = friends
        self.filteredList = friends
        if self.filteredList.count == 0 {
            loadDataFromVk()
        }
        self.tableView?.reloadData()
    }
}

extension MyFriendsViewController {
    

    @objc func handlerRefresh(){
        loadDataFromVk()
        refresher.endRefreshing()
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        loadDataFromVk()
    }
    
    func addSearch(){
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        usedSection.removeAll()
        if searchText != "" {
            filteredList.removeAll()
            for element in friendsInfoSorted {
                if element.friend.lowercased().contains(searchText.lowercased() ) {
                    filteredList.append(element)
                }
            }
        } else {
            filteredList = friendsInfoSorted
        }
        tableView.reloadData()
    }

    
    func addRefresher(){
        refresher = UIRefreshControl()
        tableView.addSubview(refresher)
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.tintColor = UIColor.purple
        refresher.addTarget(self, action: #selector(handlerRefresh), for: .valueChanged)
    }
    
}


