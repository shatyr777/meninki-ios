//
//  Cart.swift
//  Meninki
//
//  Created by Shirin on 4/30/23.
//

import Foundation

struct Cart: Codable {
    var id: String
    var shop: UserProfile
    var products: [Card]
}
