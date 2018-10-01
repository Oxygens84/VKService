//
//  PhotoLike.swift
//  VKServiceApp
//
//  Created by Oxana Lobysheva on 01/10/2018.
//  Copyright © 2018 Oxana Lobysheva. All rights reserved.
//

import UIKit

enum Flag: Int {
    case like, dislike
    static let allOptions: [Flag] = [like, dislike]
    //static let allOptions: [Flag] = [like, dislike, noData]
    
    var title: String {
        switch self {
        case .like: return "Like"
        case .dislike: return "Dislike"
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
            let button = UIButton.init(type: .system)
            button.setTitle(optionSelected.title, for: [])
            button.setTitleColor(.lightGray, for: .normal)
            button.setTitleColor(.white, for: .selected)

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
        for (index,button) in self.buttons.enumerated() {
            guard let option = Flag(rawValue: index) else { continue }
            button.isSelected = option == self.flag
        }
    }
    
    @objc func optionSelected(_ sender: UIButton){
        guard let index = self.buttons.index(of: sender) else { return }
        guard let option = Flag(rawValue: index) else { return }
        self.flag = option
    }
}
