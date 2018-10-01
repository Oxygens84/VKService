import UIKit

//
//  ImageBuilder.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 30/09/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit

@IBDesignable class ViewBuilder: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    func setup () {
        setShadow()
    }
    
    func setShadow() {
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.shadowRadius = 6.0
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize.zero
    }
    
    
    
    
    
}

