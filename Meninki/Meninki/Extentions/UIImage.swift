//
//  UIImage.swift
//  BaseApp
//
//  Created by Shirin on 3/24/23.
//

import UIKit.UIImageView

extension UIImageView {
    
    convenience init(contentMode: UIView.ContentMode,
                     cornerRadius: CGFloat,
                     image: UIImage? = nil,
                     backgroundColor: UIColor = .neutralDark,
                     tintColor: UIColor = .contrast) {
        
        self.init(frame: .zero)
        self.contentMode = contentMode
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.image = image
        self.clipsToBounds = true
        self.tintColor = tintColor
    }
}
