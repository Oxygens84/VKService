//
//  VkService.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 06/11/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import Foundation
import WebKit
import RealmSwift

enum DefaultKey {
    static let tokenField = "token"
}

class DataService {
    
    let baseUrl = "https://api.vk.com/method/"
    var apiKey: String
    var user: Int
    var version: String = "5.92"
    var sharedDefaults = UserDefaults(suiteName: "group.ru.vkServiceApp")
    
    init(){
        if Session.shared.token != nil {
            self.apiKey = Session.shared.token!
        } else {
            self.apiKey = sharedDefaults?.string(forKey: DefaultKey.tokenField) ?? "noKey"
        }
        self.user = Session.shared.userId ?? -1
        if let key = Session.shared.token {
            sharedDefaults?.set(key, forKey: DefaultKey.tokenField)
        }
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
            URLQueryItem (name: "scope" , value: "270342" ),
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
            realm.add(data, update: true)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func rewriteData<T: Object>(_ data: [T], user: Int? = nil){
        do {
            let realm = try Realm()
            realm.beginWrite()
            var oldElements: [T];
            if user != nil {
                oldElements = Array(realm.objects(T.self).filter("user_id == %@", user!))
            } else {
                oldElements = Array(realm.objects(T.self))
            }
            realm.delete(oldElements)
            realm.add(data)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    //TODO add getAuthorFromVk
    func getPostAuthor(user: Int) -> String{
        var name: String = ""
        do {
            let realm = try Realm()
            if user >= 0 {
                let element = realm.objects(Friend.self).filter("id == %@", user).first
                name = element?.friend ?? ""
            } else {
                let element = realm.objects(Group.self).filter("id == %@", abs(user)).first
                name = element?.group ?? ""
            }
        } catch {
            print(error)
        }
        return name
    }
    
    
    func loadFromRealm<T: Object>(user: Int? = nil) -> [T]{
        do {
            let realm = try Realm()
            var res: [T];
            if user != nil {
                res = Array(realm.objects(T.self).filter("user_id == %@", user!))
            } else {
                res = Array(realm.objects(T.self))
            }
            return res
        } catch {
            print(error)
            return []
        }
    }

}

