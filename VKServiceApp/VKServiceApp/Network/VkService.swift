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

class VkService {
    
    let baseUrl = "https://api.vk.com/method/"
    var apiKey: String
    var user: Int
    var version = 5.80
    
    init(){
        self.apiKey = Session.shared.token!
        self.user = Session.shared.userId!
    }
    
    func loadMyFriends(){
        let method = "apps.getFriendsList?"
        let parameters: Parameters = [
            "extended": 1,
            "access_token": apiKey,
            "v": version
        ]
        let url = baseUrl + method
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
            response in print(response)
        }
    }
    
    func loadUserPhotos(userId: Int){
        let method = "photos.getUserPhotos?"
        let parameters: Parameters = [
            "user_id": userId,
            "access_token": apiKey,
            "v": version
        ]
        let url = baseUrl + method
        print(url)
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
            response in print(response)
        }
    }
    
    func loadMyGroups(){
        let method = "groups.get?"
        let parameters: Parameters = [
            "user_id": user,
            "fields": "members_count",
            "extended": 1,
            "access_token": apiKey,
            "v": version
        ]
        let url = baseUrl + method
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
            response in print(response)
        }
    }
    
    func loadGroupsBy(searchText: String){
        let method = "groups.search?"
        let parameters: Parameters = [
            "q": searchText,
            "type": "group",
            "count": 10,
            "access_token": apiKey,
            "v": version
        ]
        let url = baseUrl + method
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
            response in print(response)
        }
    }
    
    
    static func webViewLoadData(view : WKWebView) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem (name: "client_id" , value: "6743912" ),
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
}
