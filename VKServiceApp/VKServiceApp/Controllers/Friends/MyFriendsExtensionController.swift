//
//  MyFriendsExtensionController.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 25/12/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit

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
        self.tableView?.reloadData()
    }
    
    func addRefresher(){
        refresher = UIRefreshControl()
        tableView.addSubview(refresher)
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.tintColor = UIColor.purple
        refresher.addTarget(self, action: #selector(handlerRefresh), for: .valueChanged)
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
    
    func getFirstLetter(_ text: String) -> String{
        return String(text.prefix(1))
    }
    
    func loadDataFromVk(){
        usedSection.removeAll()
        service.loadFriendDataWithAlamofire() { (friends, error) in
            if let error = error {
                print(error)
            }
            if let friends = friends?.sorted(by: { $0.friend < $1.friend }) {
                self.friendsInfoSorted = friends
                self.filteredList = friends
            }
        }
        self.tableView?.reloadData()
    }
    
    func loadDataFromRealm(){
        usedSection.removeAll()
        let friends = service.loadFriendsFromRealm().sorted(by: { $0.friend < $1.friend })
        self.friendsInfoSorted = friends
        self.filteredList = friends
        if self.filteredList.count == 0 {
            loadDataFromVk()
        }
        self.tableView?.reloadData()
    }
    
    func observeFriends(){
        let data = realm.objects(Friend.self)
        print(data)
        notificationToken = data.observe { (changes) in
            switch changes {
            case .initial(let results):
                print(results)
                self.loadDataFromRealm()
            case .update(let results, let deletions, let insertions, let modifications):
                print(results)
                print(deletions)
                print(insertions)
                print(modifications)
                self.loadDataFromRealm()
            case .error(let error):
                print(error)
            }
        }
    }
}
