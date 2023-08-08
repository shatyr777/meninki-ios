//
//  ChangeSubscription.swift
//  Meninki
//
//  Created by Shirin on 2/24/23.
//

import Foundation

struct ChangeSubscription: Codable {
    var id: String
    var isSubscribe: Bool
}

struct ChangeRating: Codable {
    var id: String
    var isIncrease: Bool
}

struct ChangeOrder: Codable {
    var id: String
    var orderStatus: OrderStatus.RawValue = OrderStatus.delivered.rawValue
}
