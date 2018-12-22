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

class NewsService: DataService {
    
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
            if let value = response.data, let json = try? JSON(data: value){
                let news = json["response"]["items"].arrayValue.map{ News(json: $0) }
                completion?(news, nil)
            }
        }
    }
    
}
