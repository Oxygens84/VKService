//
//  FriendService.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 09/11/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class FriendService: DataService {
    
    func loadFriendDataWithAlamofire(completion: (([Friend]?, Error?) -> Void)?) {
        let method = "apps.getFriendsList?"
        let parameters: Parameters = [
            "extended": 1,
            "count": 5000,
            //crop_photo
            "fields": "photo_50",
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
                    let friends = json["response"]["items"].arrayValue.map{ Friend(json: $0) }
                    DispatchQueue.main.async {
                        self.rewriteData(friends)                        
                        completion?(friends, nil)
                    }
                }
            }
        }
    }
    
    
    func loadPhotoDataWithAlamofire(friend: Friend, completion: (([FriendPhoto]?, Error?) -> Void)?) {
        let method = "photos.getAll?"
        let parameters: Parameters = [
            "owner_id": friend.id,
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
                    let friendPhotos = json["response"]["items"].arrayValue.map{ FriendPhoto(json: $0, friendInfo: friend)}
                    DispatchQueue.main.async{
                        self.rewriteData(friendPhotos, user: friend.id)
                        completion?(friendPhotos, nil)
                    }
                }
            }
        }
    }
}
