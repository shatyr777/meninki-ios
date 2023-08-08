//
//  Product.swift
//  Meninki
//
//  Created by NyanDeveloper on 10.12.2022.
//

import Foundation

struct ProductInfo: Codable {
    var id: String
    var name: String
    var description: String
    var count: Int?
    var price: Int?
    var discountPrice: Int?
    var user: User?
    var shop: User?
    var categories: [Category]?
    var options: [Option]?
    var optionTitles: [String]?
    var personalCharacteristics: [PersonalCharacteristics]?
    var medias: [Image]
    var rating: Rating?
    var isFavorited: Bool?
    var inCartCount: Int?
    var productId: String?
}

struct Image: Codable {
    var id: String
    var orientationType: Int
    var path: String
}

struct Rating: Codable {
    var userRating: Dictionary<String, Bool>?
    var total: Int?
}

struct Option: Codable, Equatable {
    var id: String?
    var optionLevel: Int?
    var optionType: Int?
    var value: String?
    var imagePath: String?
    var productId: String
}

struct PersonalCharacteristics: Codable {
    var id: String?
    var productId: String?
    var options: [Option]?
    var count: Int?
    var price: Double?
    var priceDiscount: Double?
}
