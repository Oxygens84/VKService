//
//  MyGroupsViewCell.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 27/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit
import Kingfisher

class MyGroupsViewCell: UITableViewCell {

    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupAvatar: UIImageView!

    func configure(group: Group){
        groupName.text = group.getGroupName()
        groupAvatar.kf.setImage(with: URL(string: group.getGroupAvatar()))
    }
    
}
