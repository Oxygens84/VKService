//
//  FirebaseUser.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 01/12/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import Foundation
import Firebase

class FirebaseUser {
    
    var userId: Int
    var groups: [Int]
    var ref: DatabaseReference?
    
    init(userId: Int, groups: [Int]){
        self.ref = nil
        self.userId = userId
        self.groups = groups
        
    }
    
    init?(snapShot: DataSnapshot){
        guard let value = snapShot.value as? [String: Any],
              let groups = value["groups"] as? [Int],
              let userId = value["userId"] as? Int else {
                return nil
        }
        self.ref = snapShot.ref
        self.userId = userId
        self.groups = groups
    }
    
    func toAnyObject() -> [String: Any] {
        return [
            "userId": userId,
            "groups": groups
        ]
    }
}
