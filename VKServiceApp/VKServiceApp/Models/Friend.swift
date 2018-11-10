//
//  Friend.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 26/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import Foundation

class Friend {
    
    var id: Int
    var friend: String
    var avatar: String
    var avatarLikes: Int
    var myAvatarLike: Bool
    
    init(id: Int, friend: String, avatar: String, avatarLikes: Int){
        self.id = id
        self.friend = friend
        self.avatar = avatar
        self.avatarLikes = avatarLikes
        self.myAvatarLike = false
    }
    
    
    init(json: [String: Any]) {
        if let id = json["id"] as? Int {
            self.id = id
        } else {
            self.id = -1
        }
        friend = ""
        if let friendName = json["first_name"] as? String {
            self.friend += friendName
        }
        if let friendSurname = json["last_name"] as? String {
            if friend.count > 1 {
                self.friend += " "
            }
            self.friend += friendSurname
        }
        if let avatar = json["photo_50"] as? String {
            self.avatar = avatar
        } else {
            self.avatar = Defaults.friendName.rawValue
        }
        //TODO: get Likes from VK
        self.avatarLikes = 100
        self.myAvatarLike = false
    }
    
    func getFriendId() -> Int{
        return id
    }
    
    
    func getFriendName() -> String{
        return friend
    }
    
    func getFriendAvatar() -> String{
        return avatar
    }
    
    func getAvatarLikes() -> Int{
        return avatarLikes
    }
    
    func setAvatarLikes(total: Int){
        avatarLikes = total
    }
    
    func getMyAvatarLike() -> Bool{
        return myAvatarLike
    }
    
    func setMyAvatarLike(_ value: Bool){
        myAvatarLike = value
    }
}
