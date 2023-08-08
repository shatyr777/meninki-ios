//
//  AccountUserDefaults.swift
//  BaseApp
//
//  Created by Shirin on 3/24/23.
//

import Foundation

private enum Defaults: String {
    case language = "language"
    
    case id = "id"
    case username = "username"
    case name = "name"
    case phone = "phone"
    case email = "email"
    case avatar = "avatar"

    case token = "token"
    case refreshToken = "refreshToken"
    case validTo = "validTo"
    
    case shops = "shops"
    case shopIds = "shopIds"
    case addresses = "addresses"
    
    case search = "search_history"
}

class AccUserDefaults {

    static var language: String {
        set { _set(value: newValue, key: .language)  }
        get { return _get(valueForKey: .language) as? String ?? ""}
    }
    
    static var id: String {
        set { _set(value: newValue, key: .id)  }
        get { return _get(valueForKey: .id) as? String ?? ""}
    }
    
    static var name: String {
        set { _set(value: newValue, key: .name) }
        get { return _get(valueForKey: .name) as? String ?? ""}
    }
    
    static var username: String {
        set { _set(value: newValue, key: .username) }
        get { return _get(valueForKey: .username) as? String ?? ""}
    }
    
    static var phone: String? {
        set { _set(value: newValue, key: .phone)  }
        get { return _get(valueForKey: .phone) as? String}
    }

    static var email: String? {
        set { _set(value: newValue, key: .email)  }
        get { return _get(valueForKey: .email) as? String }
    }
    
    static var avatar: String? {
        set { _set(value: newValue, key: .avatar)  }
        get { return _get(valueForKey: .avatar) as? String}
    }

    
    static var token: String {
        set { _set(value: newValue, key: .token)  }
        get { return _get(valueForKey: .token) as? String ?? ""}
    }

    static var refreshToken: String {
        set { _set(value: newValue, key: .refreshToken)  }
        get { return _get(valueForKey: .refreshToken) as? String ?? ""}
    }

    static var validTo: String {
        set { _set(value: newValue, key: .validTo)  }
        get { return _get(valueForKey: .validTo) as? String ?? ""}
    }
    
    static var shopIds: [String] {
        set { _set(value: newValue, key: .shopIds)}
        get { return _get(valueForKey: .shopIds) as? [String] ?? []}
    }
    
    static var addresses: [String] {
        set { _set(value: newValue, key: .addresses)}
        get { return _get(valueForKey: .addresses) as? [String] ?? []}
    }
    
    static var shops: [String] {
        set { _set(value: newValue, key: .shops)}
        get { return _get(valueForKey: .shops) as? [String] ?? []}
    }
    
    static var searchHistory: [String] {
        set { _set(value: newValue, key: .search) }
        get { return _get(valueForKey: .search) as? [String] ?? [] }
    }
    
    class func saveToken(_ data: Token){
        token = data.accessToken
        refreshToken = data.refreshToken
        validTo = data.validTo
        id = data.userId ?? ""
    }
    
    class func saveUser(_ data: User){
        username = data.userName ?? ""
        name = data.name
        phone = data.phoneNumber
        email = data.email
        avatar = data.imgPath
    }
    
    class func saveUser(_ data: UserProfile?){
        guard let data = data else { return }
        username = data.userName ?? ""
        name = data.name
        phone = data.phoneNumber
        email = data.email
        avatar = data.imagePath
    }
    
    class func clear(){
        id = ""
        name = ""
        username = ""
        phone = ""
        email = ""
        avatar = ""
        token = ""
        refreshToken = ""
        validTo = ""
        shopIds = []
        addresses = []
        shops = []
    }
}

extension AccUserDefaults {
    private static func _set(value: Any?, key: Defaults) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }

    private static func _get(valueForKey key: Defaults)-> Any? {
        return UserDefaults.standard.value(forKey: key.rawValue)
    }
}
