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
