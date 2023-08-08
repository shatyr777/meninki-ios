//
//  Header.swift
//  Meninki
//
//  Created by Shirin on 3/29/23.
//

import UIKit

class Header: UIStackView {

    var bg = UIView()
    
    var backBtn = IconBtn(icon: UIImage(named: "back"))
    
    var title = UILabel(font: .sb_16,
                        color: .contrast,
                        alignment: .left,
                        numOfLines: 0,
                        text: "header")
    
    var trailingBtn = IconBtn(icon: nil, tintColor: .contrast)
    
    init(title: String, trailingIcon: UIImage? = nil) {
        super.init(frame: .zero)
        setupView()
        
        self.title.text = title
        if trailingIcon == nil {
            trailingBtn.removeFromSuperview()
        } else {
            trailingBtn.setImage(trailingIcon, for: .normal)
        }
        
        bg = addBackground(color: .lowContrast,
                           cornerRadius: .zero)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        axis = .horizontal
        alignment = .center
        spacing = 0
        addMargins(insets: UIEdgeInsets(edges: 10))
        
        addArrangedSubviews([backBtn,
                             title,
                             trailingBtn])
    }
}
