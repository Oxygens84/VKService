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
    
    init(friend: String, avatar: String){
        self.friend = friend
        self.avatar = avatar
    }
    
    func getFriendName() -> String{
        return friend
    }
    
    func getFriendAvatar() -> String{
        return avatar
    }
}
