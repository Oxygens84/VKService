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
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        manualLayout()
    }
    
    func manualLayout(){

        friendAvatar.pin
            .top()
            .left()
            .bottom()
            .size(70)

        friendName.pin
            .after(of: friendAvatar)
            .top()
            .right()
            .bottom()
            .marginLeft(10)
            .height(70)

    }
}
