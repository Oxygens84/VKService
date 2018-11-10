//
//  Group.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 27/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import Foundation

class Group {
    
    var id: Int = -1
    var group: String = ""
    var avatar: String = ""
    var members: Int = 0
    
    init(id: Int, group: String, avatar: String, members: Int){
        self.id = id
        self.group = group
        self.avatar = avatar
        self.members = members
    }
    
    init(json: [String: Any]) {
        if let id = json["id"] as? Int {
            self.id = id
        }
        if let groupName = json["name"] as? String {
            self.group = groupName
        }
        if let members = json["members_count"] as? Int {
            self.members = members
        }
        if let avatar = json["photo_50"] as? String {
            self.avatar = avatar
        }
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
