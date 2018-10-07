//
//  News.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 07/10/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import Foundation

class News {
    
    var title: String
    var image: String
    var comments: [String]
    var myLike: Bool
    var commentsCount: Int
    var likesCount: Int
    var viewsCount: Int
    
    init(title: String, image: String, likesCount: Int, commentsCount: Int, viewCounts: Int){
        self.title = title
        self.image = image
        self.comments = []
        self.myLike = false
        self.likesCount = likesCount
        self.commentsCount = commentsCount
        self.viewsCount = viewCounts
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


