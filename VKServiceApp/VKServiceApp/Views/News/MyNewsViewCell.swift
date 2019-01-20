//
//  MyNewsViewCell.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 07/10/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit
import Kingfisher
import PinLayout

class MyNewsViewCell: UITableViewCell {
    
    let service = NewsService()
    
    @IBOutlet weak var authorAvatar: UIImageView!    
    @IBOutlet weak var authorName: UILabel!
    
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    
    @IBOutlet weak var heart: UIView!
    @IBOutlet weak var message: UIView!
    
    @IBOutlet weak var newsLikes: UILabel!
    @IBOutlet weak var newsComments: UILabel!
    
    @IBOutlet weak var newsViewsIcon: UIView!
    
    @IBAction func newsSendButton(_ sender: Any) {
    }
    
    @IBOutlet weak var newsViews: UILabel!
    
    public func configure(with news: News) {
        
        self.authorAvatar.kf.setImage(with: URL(string: service.getPostAuthorAvatar(user: news.ownerId)))
        self.authorName.text = service.getPostAuthor(user: news.ownerId)
        self.newsTitle.text = news.getTitle()
        self.newsImage.kf.setImage(with: URL(string: news.getImage()))
        self.newsLikes.text = String(news.getLikesCount())
        self.newsComments.text = String(news.getCommentsCount())
        self.newsViews.text = String(news.getViewsCount())

        setCircleFrame()
        setNeedsLayout()
    }
    
    func setCircleFrame(){
        authorAvatar.contentMode = .scaleAspectFill
        authorAvatar.layer.cornerRadius = authorAvatar.bounds.height / 2
        authorAvatar.layer.borderColor = UIColor.black.cgColor
        authorAvatar.layer.borderWidth = 1.0
        authorAvatar.layer.masksToBounds = true
    }

}
