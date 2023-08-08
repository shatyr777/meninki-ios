//
//  ApiPath.swift
//  Meninki
//
//  Created by Shirin on 3/29/23.
//

import Foundation

class ApiPath {
    
    static let BASE_URL = "https://meninki.com.tm/"
    
    /// AUTH
    static let SEND_OTP = BASE_URL+"api/User/Registration"
    static let CHECK_OTP = BASE_URL+"api/User/ConfirmationPhoneNumber"
    static let REGISTER_APPLE = BASE_URL+"api/User/Registration-by-google"
    static let UPDATE_USER = BASE_URL+"api/User"
    static let DELETE_USER = BASE_URL+"api/User/Block"

    //USER
    static let GET_USER_PROFILE = BASE_URL + "api/User/GetById/"
    static let GET_SHOP_PROFILE = BASE_URL +  "api/Shop/GetById/"

    static let CHANGE_USER_SUBSCRIPTION = BASE_URL + "api/User/Subscribe"
    static let CHANGE_SHOP_SUBSCRIPTION = BASE_URL + "api/Shop/Subscribe"

    static let GET_SHOP_SUBSCRIBES_OF_SHOP = BASE_URL + "api/User/GetShopSubscriber"
    static let GET_USER_SUBSCRIBERS_OF_SHOP = BASE_URL + "api/Shop/GetUserSubscriber"
    static let GET_USER_SUBSCRIBES_OF_USER = BASE_URL + "api/User/GetSubscriber"
    
    static let ADD_SHOP = BASE_URL + "api/Shop"

    //Product
    static let GET_CATEGORIES = BASE_URL + "api/Category"
    static let GET_PRODUCTS = BASE_URL + "api/Card"
    static let GET_ONE_PRODUCT = BASE_URL + "api/Product/GetById/"
    static let GET_HOME = BASE_URL + "api/MainScreen/Part-"
    
    static let GET_IN_CART = BASE_URL + "api/Order/GetAll"
    static let ADD_TO_CART = BASE_URL + "api/Order/AddCart"
    static let BUY_PRODUCT = BASE_URL + "api/Order/PlaceOrder"
    static let GET_SHOP_ORDERS = BASE_URL + "api/Order/GetByStatuses"
    static let CHANGE_ORDER_STATUS = BASE_URL + "api/ChangeStatus/Order"

    //POST
    static let GET_POSTS = BASE_URL + "api/Post/GetAll"
    static let LIKE_POST = BASE_URL + "api/ChangeRating/Product"

    //ADD
    static let ADD_POST = BASE_URL + "api/Post"
    
    static let ADD_PRODUCT = BASE_URL + "api/Product/CreateProduct"
    static let UPDATE_PRODUCT = BASE_URL + "api/Product/UpdateProduct"
    static let ADD_OPTIONS = BASE_URL + "api/Product/CreateOption"
    static let ADD_CHARS = BASE_URL + "api/Product/UpdatePersonalCharacteristics"
    static let GET_CHARS = BASE_URL + "api/Product/PersonalCharacteristics"

    
    static let UPLOAD_IMG = BASE_URL + "api/Image/CreateRangeImage"
    static let UPLOAD_VIDEO = BASE_URL + "api/Video"
    
    static func getUrl(path: String) -> URL {
        return URL(string: ApiPath.BASE_URL+path)!
    }
}
