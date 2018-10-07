//
//  Friend.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 26/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import Foundation

class Friend {
    
    var friend: String
    var avatar: String
    var avatarLikes: Int
    var myAvatarLike: Bool
    
    init(friend: String, avatar: String, avatarLikes: Int){
        self.friend = friend
        self.avatar = avatar
        self.avatarLikes = avatarLikes
        self.myAvatarLike = false
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
