//
//  MyFriendsViewCell.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 26/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit
import Kingfisher

class MyFriendsViewCell: UITableViewCell {
    
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendAvatar: UIImageView!

    
    func configure(friend: Friend){
        friendName.text = friend.friend
        friendAvatar.kf.setImage(with: URL(string: friend.avatar))
    }
}
