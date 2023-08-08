//
//  GetOrders.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 08.05.2023.
//

import Foundation

struct GetOrders: Codable {
    var statuses: [OrderStatus.RawValue]
    var shopId: String
}

