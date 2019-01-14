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
    
    let marginDefault: CGFloat = 10
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //manualLayout()
    }
    
    public func configure(with news: News) {
        
        self.newsTitle.text = service.getPostAuthor(user: news.ownerId) + " \n" + news.getTitle()
        self.newsImage.kf.setImage(with: URL(string: news.getImage()))
        self.newsLikes.text = String(news.getLikesCount())
        self.newsComments.text = String(news.getCommentsCount())
        self.newsViews.text = String(news.getViewsCount())
        
        //setNeedsLayout()
    }
    
    func manualLayout(){
        
        newsTitle.pin
            .topLeft()
            .width(100%)
            //.height(300)
        
        newsImage.pin
            .verticallyBetween(newsTitle, and: heart)
            .marginTop(marginDefault)
            .width(100%)
            .sizeToFit(.width)
        
        heart.pin
            .below(of: newsImage, aligned: .left)
            .marginTop(marginDefault)
            .left(marginDefault)
            .size(30)
        
        newsLikes.pin
            .after(of: heart)
            .marginLeft(marginDefault)
            .size(30)
        
        message.pin
            .after(of: newsLikes)
            .marginLeft(marginDefault)
            .size(30)
        
        newsComments.pin
            .after(of: message)
            .marginLeft(marginDefault)
            .size(30)
        
        //newsSendButton.pin.after(of: newsComments, aligned: .left).marginLeft(10).height(30).width(30)
        
        newsViewsIcon.pin
            .after(of: newsComments)
            .marginLeft(marginDefault)
            .size(30)
        
        newsViews.pin
            .after(of: newsViewsIcon)
            .marginLeft(marginDefault)
            .size(30)

    }
}
