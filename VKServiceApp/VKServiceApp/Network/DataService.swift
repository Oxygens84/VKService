//
//  VkService.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 06/11/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import Foundation
import Alamofire
import WebKit
import RealmSwift

enum DefaultKey {
    static let tokenField = "token"
}

class DataService {
    
    let baseUrl = "https://api.vk.com/method/"
    var apiKey: String
    var user: Int
    var version = 5.80
    
    init(){
        self.apiKey = Session.shared.token!
        self.user = Session.shared.userId!
    }

    
    static func webViewLoadData(view : WKWebView) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem (name: "client_id" , value: "6747758" ),
            URLQueryItem (name: "display" , value: "mobile" ),
            URLQueryItem (name: "redirect_uri" ,
                          value: "https://oauth.vk.com/blank.html" ),
            URLQueryItem (name: "scope" , value: "262150" ),
            URLQueryItem (name: "response_type" , value: "token" ),
            URLQueryItem (name: "v" , value: "5.68" )
        ]
        let request = URLRequest (url: urlComponents.url!)
        view.load(request)
    }
    
    
    func saveData(_ data: [Object]){
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(data)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func deleteData(_ data: Object){
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.delete(data)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func rewriteData<T: Object>(_ data: [T]){
        do {
            let realm = try Realm()
            realm.beginWrite()
            //let oldElements = realm.objects(Friend.self)
            //realm.delete(oldElements)
            //realm.add(data, update: true)
            realm.add(data, update: true)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func rewriteData(_ data: [FriendPhoto], user: Int){
        do {
            let realm = try Realm()
            realm.beginWrite()
            let oldElements = realm.objects(FriendPhoto.self).filter("user_id == %@", user)
            realm.delete(oldElements)
            realm.add(data)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func rewriteData(_ data: [Group], owner: String){
        do {
            let realm = try Realm()
            realm.beginWrite()
            let oldElements = realm.objects(Group.self).filter("owner == %@", owner)
            realm.delete(oldElements)
            realm.add(data)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func loadFriendsFromRealm() -> [Friend]{
        do {
            let realm = try Realm()
            return Array(realm.objects(Friend.self))
        } catch {
            print(error)
            return []
        }
    }
    
    func loadPhotosFromRealm(user: Int) -> [FriendPhoto]{
        do {
            let realm = try Realm()
            return Array(realm.objects(FriendPhoto.self).filter("user_id == %@", user))
        } catch {
            print(error)
            return []
        }
    }
    
    func loadGroupsFromRealm() -> [Group]{
        do {
            let realm = try Realm()
            return Array(realm.objects(Group.self))
        } catch {
            print(error)
            return []
        }
    }
}
