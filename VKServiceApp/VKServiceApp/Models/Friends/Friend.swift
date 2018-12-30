//
//  Friend.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 26/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Friend: Object {
    
    //TO DO add user_id
    @objc dynamic var id: Int = -1
    @objc dynamic var friend: String = ""
    @objc dynamic var avatar: String = ""
    @objc dynamic var avatarLikes: Int = 0
    @objc dynamic var myAvatarLike: Bool = false
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["id"]
    }
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.friend = json["first_name"].stringValue + " " + json["last_name"].stringValue
        self.avatar = json["photo_50"].stringValue
        //TODO: get Likes from VK, move to FriendPhotoPage
        self.avatarLikes = 100
        self.myAvatarLike = false
    }
    
    convenience init(id: Int, friend: String, avatar: String, avatarLikes: Int, myAvatarLike: Bool ) {
        self.init()
        self.id = id
        self.friend = friend
        self.avatar = avatar
        self.avatarLikes = avatarLikes
        self.myAvatarLike = myAvatarLike
    }
    
}
