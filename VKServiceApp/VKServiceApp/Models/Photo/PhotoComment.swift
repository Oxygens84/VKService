//
//  PhotoComment.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 07/10/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit

enum Options: Int {
    
    case comment
    static let allOptions: [Options] = [comment]
    
    var title: String {
        switch self {
        case .comment: return " feedback "
        }
    }
}


@IBDesignable class PhotoComment: UIControl {
    
    var option: Options? = nil {
        didSet {
            self.updateSelectedOption()
            self.sendActions(for: .valueChanged)
        }
    }
    
    
    private var isCommented: Bool = false
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
        for optionSelected in Options.allOptions {
            let button = UIButton.init(type: .system)
            button.setImage(#imageLiteral(resourceName: "CommentButton").withRenderingMode(.alwaysTemplate), for: .normal)
            if isCommented {
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
            if !isCommented {
                isCommented = true
                button.tintColor = UIColor.red
            } 
        }
    }
    
    @objc func optionSelected(_ sender: UIButton){
        guard let index = self.buttons.index(of: sender) else { return }
        guard let option = Options(rawValue: index) else { return }
        self.option = option
    }
}
