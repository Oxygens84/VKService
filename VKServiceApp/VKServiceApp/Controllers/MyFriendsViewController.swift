//
//  MyFriendsViewController.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 22/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit

class MyFriendsViewController: UITableViewController {

    var friendsInfo: [Friend] = [
        Friend(friend: "Winnie", avatar: "Winnie", avatarLikes: 1005),
        Friend(friend: "Eeyore", avatar: "Eeyore", avatarLikes: 2005),
        Friend(friend: "Piglet", avatar: "Piglet", avatarLikes: 3005),
        Friend(friend: "Daddy", avatar: "Daddy", avatarLikes: 4005),
        Friend(friend: "Unknown", avatar: "Unknown", avatarLikes: 5005)
    ]
    
    var valueSentFromSecondViewController:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsInfo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.myFriendsCell.rawValue, for: indexPath) as! MyFriendsViewCell
        let friend = friendsInfo[indexPath.row]
        cell.friendName.text = friend.getFriendName()
        cell.friendAvatar.image = UIImage(named: friend.getFriendAvatar())
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let profileVC = segue.destination as? FriendInfoViewController {
            if let indexPath = tableView.indexPathForSelectedRow{
                profileVC.friend =  friendsInfo[indexPath.row]
            }
        }
    }

}
