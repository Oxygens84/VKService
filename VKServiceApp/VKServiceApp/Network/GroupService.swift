//
//  GroupService.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 09/11/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GroupService: DataService {
    
    func loadGroupDataWithAlamofire(searchText: String, completion: (([Group]?, Error?) -> Void)?) {
        let method = "groups.search?"
        let parameters: Parameters = [
            "q": searchText,
            "type": "group",
            "count": 20,
            "fields": "members_count",
            "access_token": apiKey,
            "v": version
        ]
        let url = baseUrl + method
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{(response) in
            if let error = response.error {
                completion?(nil, error)
                return
            }
            if let value = response.data, let json = try? JSON(data: value){
                let groups = json["response"]["items"].arrayValue.map{ Group(json: $0) }
                self.rewriteData(groups)
                completion?(groups, nil)
            }
        }
    }
    
    func loadMyGroupDataWithAlamofire(completion: (([Group]?, Error?) -> Void)?) {
        let method = "groups.get?"
        let parameters: Parameters = [
            "extended": 1,
            "count": 20,
            "fields": "members_count",
            "access_token": apiKey,
            "v": version
        ]
        let url = baseUrl + method
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{(response) in
            if let error = response.error {
                completion?(nil, error)
                return
            }
            if let value = response.data, let json = try? JSON(data: value){
                let myGroups = json["response"]["items"].arrayValue.map{ Group(json: $0) }
                self.rewriteData(myGroups)
                completion?(myGroups, nil)
            }
        }
    }
    
}
