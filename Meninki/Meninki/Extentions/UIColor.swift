//
//  UIColor.swift
//  BaseApp
//
//  Created by Shirin on 3/24/23.
//

import UIKit.UIColor


extension UIColor {
    static let bg = UIColor(hexString: "#FAF5F2") ?? .white
    static let onBgLc = UIColor(hexString: "#F0ECE1") ?? .white
    static let onBgLcD = UIColor(hexString: "#E7E2D6") ?? .gray
    static let textLc = UIColor(hexString: "#757377") ?? .gray
    static let neutralDark = UIColor(hexString: "#AFA8B4") ?? .gray

    static let accent = UIColor(hexString: "#7A4267") ?? .black
    static let contrast = UIColor(hexString: "#3B353F") ?? .black
    static let lowContrast = UIColor(hexString: "#F4EFEB") ?? .white
    
    static let alert = UIColor(hexString: "#B71764") ?? .red
    static let lukas = UIColor(hexString: "#FB0D7F") ?? .red
    static let oldAccent = UIColor(hexString: "#005FF0") ?? .blue
    static let oldCaption = UIColor(hexString: "#A0A0A0") ?? .gray
}


extension UIColor {
    convenience init?(hexString: String?) {
        if hexString == "" || hexString?.starts(with: "#") == false || (hexString?.count == 7) == false {
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
            return
        }
        
        let input: String! = (hexString ?? "").replacingOccurrences(of: "#", with: "").uppercased()
        var red: CGFloat = 0
        var blue: CGFloat = 0
        var green: CGFloat = 0
            
        red = Self.colorComponent(from: input, start: 0, length: 2)
        green = Self.colorComponent(from: input, start: 2, length: 2)
        blue = Self.colorComponent(from: input, start: 4, length: 2)

        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    static func colorComponent(from string: String!, start: Int, length: Int) -> CGFloat {
        let substring = (string as NSString)
            .substring(with: NSRange(location: start, length: length))
        let fullHex = length == 2 ? substring : "\(substring)\(substring)"
        var hexComponent: UInt64 = 0
        Scanner(string: fullHex)
            .scanHexInt64(&hexComponent)
        return CGFloat(Double(hexComponent) / 255.0)
    }
}
