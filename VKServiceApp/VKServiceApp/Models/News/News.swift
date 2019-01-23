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
        
        self.title = getPostTitle(from: json)
        self.image = getPostImageUrl(from: json)
        self.comments = []
        self.myLike = getPostMyLike(from: json)
        self.likesCount = getPostLikesCount(from: json)
        self.commentsCount = getPostCommentsCount(from: json)
        self.viewsCount = getPostViewCount(from: json)
        self.ownerId = getPostOwnerId(from: json)
    }
    
    convenience init(title: String, image: String, comments: [String], myLike: Bool, commentsCount: Int, likesCount: Int, viewsCount: Int, ownerId: Int){
        self.init()
        self.title = title
        self.image = image
        self.comments = []
        self.myLike = myLike
        self.likesCount = likesCount
        self.commentsCount = commentsCount
        self.viewsCount = viewsCount
        self.ownerId = ownerId
    }

    
    func getPostLikesCount(from json: JSON) -> Int {
        return json["likes"]["count"].intValue
    }
    
    func getPostCommentsCount(from json: JSON) -> Int {
        return json["comments"]["count"].intValue
    }
    
    func getPostViewCount(from json: JSON) -> Int {
        return json["views"]["count"].intValue
    }
    
    func getPostOwnerId(from json: JSON) -> Int {
        if (json["copy_history"].arrayValue.count > 0){
            return json["copy_history"][0]["owner_id"].intValue
        }
        return json["attachments"][0]["photo"]["owner_id"].intValue
    }
    
    func getPostMyLike(from json: JSON) -> Bool {
        if !(json["likes"]["user_likes"].intValue == 0) {
            return true
        }
        return false
    }
    
    func getPostTitle(from json: JSON) -> String {
        if (json["copy_history"].arrayValue.count > 0){
            return json["copy_history"][0]["text"].stringValue
        }
        return json["text"].stringValue
    }
    
    func getPostImageUrl(from json: JSON) -> String {
        if (json["copy_history"].arrayValue.count > 0) {
            if (json["copy_history"][0]["attachments"][0]["type"].stringValue == "album"){
                return json["copy_history"][0]["attachments"][0]["album"]["thumb"]["sizes"][0]["url"].stringValue
            } else {
                return json["copy_history"][0]["attachments"][0]["photo"]["sizes"][0]["url"].stringValue
            }
        } else {
            if (json["attachments"][0]["type"].stringValue == "album"){
                return json["attachments"][0]["album"]["photo"]["sizes"][0]["url"].stringValue
            } else {
                let maxPhoto = json["attachments"][0]["photo"]["sizes"].arrayValue.count
                if maxPhoto > 0 {
                    return json["attachments"][0]["photo"]["sizes"][maxPhoto-1]["url"].stringValue
                }
            }
        }
        return ""
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
