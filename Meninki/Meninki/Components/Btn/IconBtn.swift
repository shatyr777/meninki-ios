//
//  IconBtn.swift
//  Meninki
//
//  Created by Shirin on 3/29/23.
//

import UIKit
import EasyPeasy

class IconBtn: BaseBtn {

    init(icon: UIImage?, tintColor: UIColor? = nil){
        super.init(frame: .zero)
        
        if tintColor != nil {
            setImage(icon?.withRenderingMode(.alwaysTemplate),
                     for: .normal)
            imageView?.tintColor = tintColor
        } else {
            setImage(icon, for: .normal)
        }
        
        easy.layout(Size(40).with(.high))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
