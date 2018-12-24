//
//  FriendInfoViewCell.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 26/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit
import Kingfisher

class FriendInfoViewCell: UICollectionViewCell {

    @IBOutlet weak var friendPhoto: UIImageView!
    @IBOutlet weak var likeFriendPhoto: UILabel!
    @IBOutlet weak var heart: UIView!
    
    func configure(friendPhoto: FriendPhoto){
        self.friendPhoto.kf.setImage(with: URL(string: friendPhoto.photo))
    }
}
