//
//  FriendService.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 09/11/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import Foundation
import Alamofire

class FriendService: VkService {
    
    func loadFriendDataWithAlamofire(completion: (([Friend]?, Error?) -> Void)?) {
        let method = "apps.getFriendsList?"
        let parameters: Parameters = [
            "extended": 1,
            "fields": "photo_50",
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
                    let friends = items.map{ Friend(json: $0) }
                    DispatchQueue.main.async {
                        completion?(friends, nil)
                    }
                }
                return
            }
        }
    }
    
    
    func loadPhotoDataWithAlamofire(userId: Int, completion: (([FriendPhoto]?, Error?) -> Void)?) {
        let method = "photos.getAll?"
        let parameters: Parameters = [
            "owner_id": userId,
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
                    let friendPhotos = items.map{ FriendPhoto(json: $0) }
                    DispatchQueue.main.async {
                        completion?(friendPhotos, nil)
                    }
                }
                return
            }
        }
    }
}
