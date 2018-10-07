//
//  Group.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 27/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import Foundation

class Group {
    
    var id: Int
    var group: String
    var avatar: String
    var members: Int
    
    init(id: Int, group: String, avatar: String, members: Int){
        self.id = id
        self.group = group
        self.avatar = avatar
        self.members = members
    }
    
    func getGroupId() -> Int{
        return id
    }
    
    func getGroupName() -> String{
        return group
    }
    
    func getGroupAvatar() -> String{
        return avatar
    }
    
    func getGroupMembers() -> String{
        return "Members: " + String(members)
    }
    
}
