//
//  GroupService.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 09/11/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import Foundation
import Alamofire

class GroupService: VkService {
    
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
        Alamofire.request(url, method: .get, parameters: parameters).responseData{(response) in
            if let data = response.value {
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                if let json = json as? [String: Any] ,
                    let respJson = json["response"] as? [String: Any],
                    let items = respJson["items"] as? [[String: Any]]
                {
                    let groups = items.map{ Group(json: $0) }
                    DispatchQueue.main.async {
                        completion?(groups, nil)
                    }
                }
                return
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
        Alamofire.request(url, method: .get, parameters: parameters).responseData{(response) in
            if let data = response.value {
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                if let json = json as? [String: Any] ,
                    let respJson = json["response"] as? [String: Any],
                    let items = respJson["items"] as? [[String: Any]]
                {
                    let groups = items.map{ Group(json: $0) }
                    DispatchQueue.main.async {
                        completion?(groups, nil)
                    }
                }
                return
            }
        }
    }
    
}
