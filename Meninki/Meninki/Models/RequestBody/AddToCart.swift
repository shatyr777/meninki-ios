//
//  AddToCart.swift
//  Meninki
//
//  Created by Shirin on 5/1/23.
//

import Foundation

struct AddToCart: Codable {
    var productId: String
    var shopId: String
    var count: Int?
}
