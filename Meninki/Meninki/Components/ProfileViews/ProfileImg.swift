//
//  ProfileImg.swift
//  Meninki
//
//  Created by Shirin on 5/2/23.
//

import UIKit
import EasyPeasy

class ProfileImg: UIImageView {

    var clickCallback: ( ()->() )?
    
    init(size: CGFloat){
        super.init(frame: .zero)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
        
        setupView()
        easy.layout(Size(size))
        layer.cornerRadius = size/2
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        backgroundColor = .neutralDark
        contentMode = .scaleAspectFill
        layer.borderColor = UIColor.contrast.cgColor
        layer.borderWidth = 2
        clipsToBounds = true
    }
    
    @objc func click(){
        clickCallback?()
    }
}
