//
//  FriendPhoto.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 09/11/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import Foundation

class FriendPhoto{
    
    var photo: String = ""
    
    init(json: [String: Any]) {
        //photo_75 photo_130
        if let photo = json["photo_604"] as? String {
            self.photo = photo
        }
    }
    
}
