//
//  Session.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 02/11/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import Foundation

class Session {
    
    var token: String = ""
    var userId: Int = -1
    
    private init(){}
    
    public static let shared = Session()

}
