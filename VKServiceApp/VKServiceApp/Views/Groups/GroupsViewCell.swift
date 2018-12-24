//
//  GroupsViewCell.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 27/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit
import Kingfisher

class GroupsViewCell: UITableViewCell {

    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupAvatar: UIImageView!
    @IBOutlet weak var groupMembers: UILabel!

    func configure(group: Group){
        groupName.text = group.getGroupName()
        groupMembers.text = "Members: " + String(group.members)
        groupAvatar.kf.setImage(with: URL(string: group.getGroupAvatar()))
    }
}
