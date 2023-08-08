//
//  Product.swift
//  Meninki
//
//  Created by Shirin on 4/25/23.
//

import Foundation

struct Product: Codable {
    var id: String
    var name: String
    var description: String
    var shop: User?
    var price: Int?
    var discountPrice: Int?
    var categories: [Category]?
    var options: [Option]?
    var optionsConfigured: [[Option]]?
    var optionTitles: [String]?
    var personalCharacteristics: [PersonalCharacteristics]?
    var medias: [Image]
    var rating: Rating?
    var isFavorited: Bool?
    var posts: [Post]?
}

struct Image: Codable {
    var id: String
    var orientationType: Int
    var path: String?
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
