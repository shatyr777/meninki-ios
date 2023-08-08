//
//  ChangeOrder.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 08.05.2023.
//

import Foundation

struct ChangeOrder: Codable {
    var id: String
    var orderStatus: OrderStatus.RawValue = OrderStatus.delivered.rawValue
}
