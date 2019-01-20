//
//  FriendPhoto.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 09/11/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class FriendPhoto : Object {
    
    @objc dynamic var user_id: Int = 0
    @objc dynamic var photo: String = ""
    @objc dynamic var friend: Friend?
    
    override static func indexedProperties() -> [String] {
        return ["user_id"]
    }
    
    convenience init(json: JSON, friendInfo: Friend) {
        self.init()
        let maxPhoto = json["sizes"].arrayValue.count
        if maxPhoto > 0 {
            self.photo = json["sizes"][maxPhoto-1]["url"].stringValue
        }        
        self.user_id = json["owner_id"].intValue
        self.friend = friendInfo
    }
    
    
    
}
