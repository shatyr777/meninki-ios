//
//  UILabel.swift
//  BaseApp
//
//  Created by Shirin on 3/24/23.
//

import UIKit.UILabel

extension UILabel {
    convenience init(font: UIFont?,
                     color: UIColor,
                     alignment: NSTextAlignment = .left,
                     numOfLines: Int = 0,
                     text: String = "" ) {
        self.init(frame: .zero)
        self.font = font
        self.textColor = color
        self.textAlignment = alignment
        self.numberOfLines = numOfLines
        self.text = text
    }
    
    func setStrikeThroughText(_ text: String){
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
        attributedText = attributeString
    }
}
