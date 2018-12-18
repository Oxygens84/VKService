//
//  News.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 07/10/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class News {
    
    var title: String = ""
    var image: String = ""
    var comments: [String] = []
    var myLike: Bool = false
    var commentsCount: Int = 0
    var likesCount: Int = 0
    var viewsCount: Int = 0
    var ownerId: Int = -1
    
    convenience init(json: JSON) {
        self.init()
        self.title = json["text"].stringValue
        let maxPhoto = json["attachments"][0]["photo"]["sizes"].arrayValue.count
        if maxPhoto > 0 {
            self.image = json["attachments"][0]["photo"]["sizes"][maxPhoto-1]["url"].stringValue
        }
        //TODO comments
        self.comments = []
        if (json["likes"]["user_likes"].intValue == 0) {
            self.myLike = false
        } else {
            self.myLike = true
        }
        self.likesCount = json["likes"]["count"].intValue
        self.commentsCount = json["comments"]["count"].intValue
        self.viewsCount = json["views"]["count"].intValue
        self.ownerId = json["attachments"][0]["photo"]["owner_id"].intValue
    }
    
    convenience init(title: String, image: String, comments: [String], myLike: Bool, commentsCount: Int, likesCount: Int, viewsCount: Int, ownerId: Int){
        self.init()
        self.title = title
        self.image = image
        //TODO comments
        self.comments = []
        self.myLike = myLike
        self.likesCount = likesCount
        self.commentsCount = commentsCount
        self.viewsCount = viewsCount
        self.ownerId = ownerId
    }
    
    func getTitle() -> String{
        return title
    }
    
    func getImage() -> String{
        return image
    }
    
    func getComments() -> [String]{
        return comments
    }
    
    func getMyLike() -> Bool{
        return myLike
    }
    
    func getLikesCount() -> Int{
        return likesCount
    }
    
    func getCommentsCount() -> Int{
        return commentsCount
    }
    
    
    func getViewsCount() -> Int{
        return viewsCount
    }
    
    func setImageLikes(total: Int){
        likesCount = total
    }
    
    func setMyLike(value: Bool){
        myLike = value
    }
    
    func setImageComments(total: Int){
        commentsCount = total
    }
    
    func setViews(total: Int){
        viewsCount = total
    }
    
    func addComment(text: String){
        comments.append(text)
    }
    
}
