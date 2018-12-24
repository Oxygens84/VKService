//
//  Group.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 27/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Group: Object {
    
    @objc dynamic var id: Int = -1
    @objc dynamic var group: String = ""
    @objc dynamic var avatar: String = ""
    @objc dynamic var members: Int = 0
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["id"]
    }
    
    convenience init(id: Int, name: String, members: Int, avatar: String){
        self.init()
        self.id = id
        self.group = name
        self.members = members
        self.avatar = avatar
    }
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.group = json["name"].stringValue
        self.members = json["members_count"].intValue
        self.avatar = json["photo_50"].stringValue
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
