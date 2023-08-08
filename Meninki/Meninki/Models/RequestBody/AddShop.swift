//
//  AddShop.swift
//  Meninki
//
//  Created by Shirin on 5/4/23.
//

import Foundation

struct AddShop: Codable {
    var id: String?
    var name: String
    var descriptionTm: String
    var email: String
    var phoneNumber: String
    var userId: String = AccUserDefaults.id
    var categories: [String]
}

