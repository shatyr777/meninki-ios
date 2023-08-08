//
//  ShopOrder.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 08.05.2023.
//

import Foundation

struct ShopOrder: Codable {
    var id: String
    var orderStatus: OrderStatus.RawValue
    var firstName: String
    var lastName: String
    var adress: String
    var phoneNumber: String
    var products: [OrderInfo]
}

struct OrderInfo: Codable {
    var count: Int
    var personalCharacteristics: PersonalCharacteristics?
    var product: Card
}
