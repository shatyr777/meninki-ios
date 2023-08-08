//
//  User.swift
//  Meninki
//
//  Created by NyanDeveloper on 25.12.2022.
//

import Foundation

struct User: Codable {
    var id: String
    var userName: String?
    var name: String
    var phoneNumber: String?
    var email: String?
    var imgPath: String?
    var imageType: ImageType.RawValue?
}

struct UserProfile: Codable {
    var id: String
    var imagePath: String?
    var userName: String?
    var name: String
    var email: String
    var phoneNumber: String?
    var isSubscribed: Bool?
    var subscriberCount: Int?
    var subscriptionCount: Int?
    var shops: [User]?
    var totalProduct: Int?
    var placeInRating: Int?
    var description: String?
    var boughtProducts: Int?
    var favoriteCount: Int?
    var shopCount: Int?
    var orderCount: Int?
    var visiterCount: Int?
    var categories: [Category]?
}
