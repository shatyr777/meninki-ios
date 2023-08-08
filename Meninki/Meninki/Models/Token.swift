//
//  Token.swift
//  Meninki
//
//  Created by Shirin on 2/24/23.
//

import Foundation

struct Token: Codable {
    var accessToken: String
    var refreshToken: String
    var validTo: String
    var userId: String?
}
