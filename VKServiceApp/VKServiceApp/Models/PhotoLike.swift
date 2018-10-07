//
//  PhotoLike.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 01/10/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit

enum Flag: Int {
    
    case like
    static let allOptions: [Flag] = [like]
    
    var title: String {
        switch self {
        case .like: return " like "
        }
    }
}


@IBDesignable class PhotoLike: UIControl {

    var flag: Flag? = nil {
        didSet {
            self.updateSelectedOption()
            self.sendActions(for: .valueChanged)
        }
    }

    
    private var isLiked: Bool = false
    private var buttons: [UIButton] = []
    private var stack = UIStackView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        stack.frame = bounds
    }
    
    private func setupView(){
        for optionSelected in Flag.allOptions {
            print(optionSelected)
            let button = UIButton.init(type: .system)
            button.setImage(#imageLiteral(resourceName: "LikeButton").withRenderingMode(.alwaysTemplate), for: .normal)
            if isLiked {
                button.tintColor = UIColor.red
            } else {
                button.tintColor = UIColor.lightGray
            }
            button.addTarget(
                self,
                action: #selector(optionSelected(_:)),
                for: .touchUpInside
            )
            buttons.append(button)
        }
        stack = UIStackView(arrangedSubviews: self.buttons)
        self.addSubview(stack)
        
        stack.spacing = 5
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
    }
    
    private func updateSelectedOption(){
        for (_, button) in self.buttons.enumerated() {
            if !isLiked {
                isLiked = true
                button.tintColor = UIColor.red
            } else {
                isLiked = false
                button.tintColor = UIColor.lightGray
            }
        }
    }
    
    @objc func optionSelected(_ sender: UIButton){
        guard let index = self.buttons.index(of: sender) else { return }
        guard let option = Flag(rawValue: index) else { return }
        self.flag = option
    }
}