//
//  NewsViewCell.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 07/10/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit


class MyNewsViewCell: UITableViewCell {
    
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    
    @IBOutlet weak var heart: UIView!
    @IBOutlet weak var message: UIView!
    
    @IBOutlet weak var newsLikes: UILabel!
    @IBOutlet weak var newsComments: UILabel!
    
    @IBOutlet weak var newsViews: UILabel!
    
}
