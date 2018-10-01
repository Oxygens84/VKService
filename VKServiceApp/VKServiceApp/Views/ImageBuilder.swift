import UIKit

//
//  ImageBuilder.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 30/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit

@IBDesignable class ImageBuilder: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }

    func setup () {
        setCircleFrame()
    }

    func setCircleFrame(){
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
    }

}
