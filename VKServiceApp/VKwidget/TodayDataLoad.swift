//
//  TodayDataLoad.swift
//  VKwidget
//
//  Created by Oxana Lobysheva on 21/01/2019.
//  Copyright © 2019 Oxana Lobysheva. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension TodayViewController {
    
    func loadDataFromVk() {
        loadNewsWithAlamofire() { (news, error) in
            if let error = error {
                print(error)
            }
            if let news = news {
                self.news = news
                for i in news {
                    print(i.getTitle())
                }
            }
        }
    }
    
    func loadNewsWithAlamofire(completion: (([News]?, Error?) -> Void)?) {
        let method = "newsfeed.get"
        let parameters: Parameters = [
            "extended": 1,
            "filters": NewsType.post,
            "count": 3,
            "access_token": sharedDefaults?.string(forKey: DefaultKey.tokenField) ?? "noKey",
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

}
