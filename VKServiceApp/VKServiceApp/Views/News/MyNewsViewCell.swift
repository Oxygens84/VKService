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
    
    @IBOutlet weak var newsReposts: UILabel!
    @IBOutlet weak var newsViewsIcon: UIView!
    
    @IBAction func newsSendButton(_ sender: Any) {
    }
    
    @IBOutlet weak var newsViews: UILabel!
    
    public func configure(with news: News) {
        
        let image = service.getPostAuthorAvatar(user: news.ownerId)
        if !image.isEmpty {
            authorAvatar.kf.setImage(with: URL(string: service.getPostAuthorAvatar(user: news.ownerId)))
        } else {
            authorAvatar.image = UIImage(named: "Unknown")
        }
        
        authorName.text = service.getPostAuthor(user: news.ownerId)
        newsTitle.text = news.getTitle()
        newsImage.kf.setImage(with: URL(string: news.getImage()))
        newsLikes.text = String(news.getLikesCount())
        newsComments.text = String(news.getCommentsCount())
        newsReposts.text = String(news.getRepostCount())
        newsViews.text = String(news.getViewsCount())

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
