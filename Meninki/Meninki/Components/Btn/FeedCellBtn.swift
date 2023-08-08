//
//  FeedCellBtn.swift
//  Meninki
//
//  Created by Shirin on 4/1/23.
//

import UIKit
import EasyPeasy

class FeedCellBtn: UIStackView {
    
    let icon = UIImageView(contentMode: .scaleAspectFill,
                           cornerRadius: 0,
                           backgroundColor: .clear)
    
    let count = UILabel(font: .lil_12,
                        color: .bg,
                        alignment: .left,
                        numOfLines: 1,
                        text: "11")
    
    var clickCallback: ( ()->() )?
    
    init(icon: UIImage? = nil, axis: NSLayoutConstraint.Axis){
        super.init(frame: .zero)
        addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                    action: #selector(click)))
        self.axis = axis
        self.icon.easy.layout(Size(axis == .horizontal ? 16 : 28))
        self.icon.image = icon
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        spacing = 6
        alignment = .center
        icon.tintColor = .bg
        addArrangedSubviews([self.icon,
                             count])
    }
    
    @objc func click(){
        
        clickCallback?()
    }
}
