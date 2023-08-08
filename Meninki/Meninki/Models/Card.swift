//
//  Card.swift
//  Meninki
//
//  Created by Shirin on 4/3/23.
//

import Foundation

struct Card: Codable {
    var id:  String
    var name: String?
    var price: CGFloat
    var discountPrice:CGFloat
    var rating: Rating?
    var images: [String?]
    var avatar: String?
    var avatarId: String?
    var avatarType: Int
    var type: Int
    var count: Int?
}

struct Rating: Codable {
    var userRating: Dictionary<String, Bool>?
    var total: Int?
}
