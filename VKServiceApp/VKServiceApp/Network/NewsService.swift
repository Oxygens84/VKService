//
//  NewsService.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 17/12/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class NewsService: GroupService {
    
    func loadNewsPostWithAlamofire(completion: (([News]?, Error?) -> Void)?) {
        let method = "newsfeed.get"
        let parameters: Parameters = [
            "extended": 1,
            "filters": NewsType.post,
            "access_token": apiKey,
            "v": version
        ]
        let url = baseUrl + method
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{(response) in
            if let error = response.error {
                completion?(nil, error)
                return
            }
            DispatchQueue.global().async{
                if let value = response.data, let json = try? JSON(data: value){
                    let news = json["response"]["items"].arrayValue.map{ News(json: $0) }
                    DispatchQueue.main.async {
                        completion?(news, nil)
                    }
                }
            }
        }
    }
    
    func getPostAuthor(user: Int) -> String{
        var name: String = ""
        do {
            let realm = try Realm()
            //get friend
            if user >= 0 {
                if let element = realm.objects(Friend.self).filter("id == %@", user).first {
                    name = element.friend
                }
            } else {
                //get group
                if let element = realm.objects(Group.self).filter("id == %@", abs(user)).first {
                    name = element.group
                } else {
                    loadMyGroupDataWithAlamofire() { (myGroups, error) in
                        if let myGroups = myGroups {
                            for element in myGroups {
                                if element.getGroupId() == abs(user) {
                                    name = element.group
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            print(error)
        }
        return name
    }
    
    func getPostAuthorAvatar(user: Int) -> String{
        var name: String = ""
        do {
            let realm = try Realm()
            //get friend
            if user >= 0 {
                if let element = realm.objects(Friend.self).filter("id == %@", user).first {
                    name = element.avatar
                }
            } else {
                //get group
                if let element = realm.objects(Group.self).filter("id == %@", abs(user)).first {
                    name = element.avatar
                } else {
                    loadMyGroupDataWithAlamofire() { (myGroups, error) in
                        if let myGroups = myGroups {
                            for element in myGroups {
                                if element.getGroupId() == abs(user) {
                                    name = element.avatar
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            print(error)
        }
        return name
    }
}
