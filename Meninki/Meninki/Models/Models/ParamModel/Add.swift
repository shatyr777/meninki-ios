//
//  Add.swift
//  Meninki
//
//  Created by Shirin on 2/21/23.
//

import Foundation

struct AddProduct: Codable {
    var id: String
    var name: String
    var description: String
    var price: Double
    var discountPrice: Double?
    var shopId: String?
    var categoryIds: [String]? = nil
}

struct AddPost: Codable {
    var name: String
    var description: String
    var productBaseId: String
}

struct AddShop: Codable {
    var name: String
    var descriptionTm: String
    var email: String
    var phoneNumber: String
    var userId: String = AccUserDefaults.id
    var categories: [String]? = nil
}

struct AddToCart: Codable {
    var productId: String
    var count: Int?
    var shopId: String
}

