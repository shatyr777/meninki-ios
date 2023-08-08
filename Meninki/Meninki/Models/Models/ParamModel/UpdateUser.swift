//
//  UpdateUser.swift
//  Meninki
//
//  Created by Shirin on 2/20/23.
//

import Foundation

struct UpdateUser: Codable {
    var id: String = AccUserDefaults.id
    var userName: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var email: String = AccUserDefaults.email
    var phoneNumber: String = AccUserDefaults.phone
}
