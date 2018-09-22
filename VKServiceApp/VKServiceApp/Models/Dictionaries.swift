//
//  Dictionaries.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 22/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import Foundation

enum SeguesId: String {
    case goToDashboard = "goToDashboard"
    case goToAllGroups = "goToAllGroups"
    case goToFriendInfo = "goToFriendInfo"
}

enum Messages: String {
    case loginFailed = "Invalid login or password"
}

enum Titles: String {
    case error = "Error"
    case ok = "OK"
}
