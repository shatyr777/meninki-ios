//
//  UIFont.swift
//  BaseApp
//
//  Created by Shirin on 3/24/23.
//

import UIKit.UIFont

extension UIFont {
    
    static let h1 = UIFont.bold(size: 22)!
    static let h2 = UIFont.bold(size: 20)!
    static let sb_16 = UIFont.semibold(size: 16)!
    static let reviewText = UIFont.regular(size: 16)!
    static let lil_14_b = UIFont.bold(size: 14)!
    static let lil_14 = UIFont.medium(size: 14)!
    static let lil_12 = UIFont.regular(size: 12)!
    
    class func regular(size: CGFloat) -> UIFont? {
        return UIFont(name: "Inter-Regular", size: size)
    }
    
    class func medium(size: CGFloat) -> UIFont? {
        return UIFont(name: "Inter-Regular_Medium", size: size)
    }

    class func semibold(size: CGFloat) -> UIFont? {
        return UIFont(name: "Inter-Regular_SemiBold", size: size)
    }

    class func bold(size: CGFloat) -> UIFont? {
        return UIFont(name: "Inter-Regular_Bold", size: size)
    }
}
