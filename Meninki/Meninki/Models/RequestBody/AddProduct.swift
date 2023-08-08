//
//  AddProduct.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 07.05.2023.
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
