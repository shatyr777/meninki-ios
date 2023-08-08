//
//  MainCard.swift
//  Meninki
//
//  Created by NyanDeveloper on 18.12.2022.
//

import Foundation

struct MainCard: Codable {
    var id:  String
    var name: String?
    var price: CGFloat
    var discountPrice:CGFloat
    var rating: Rating?
    var images: [String]
    var avatar: String?
    var avatarId: String?
    var avatarType: Int
    var type: Int
    var count: Int?
}

