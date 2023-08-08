//
//  SubscribeRouter.swift
//  Meninki
//
//  Created by Shirin on 5/3/23.
//

import Foundation

enum SubscriberListType {
    case shopSubscribesOfUser
    case userSubscribesOfUser
    case userSubscribersOfUser
    case userSubscribersOfShop
    
    var path: String {
        switch self {
        case .userSubscribersOfShop:
            return ApiPath.GET_USER_SUBSCRIBERS_OF_SHOP
            
        case .shopSubscribesOfUser:
            return ApiPath.GET_SHOP_SUBSCRIBES_OF_SHOP
            
        case .userSubscribersOfUser:
            return ApiPath.GET_USER_SUBSCRIBES_OF_USER
            
        case .userSubscribesOfUser:
            return ApiPath.GET_USER_SUBSCRIBES_OF_USER
        }
    }

    var userType: ImageType {
       switch self {
        case .shopSubscribesOfUser:
            return .shop
            
        case .userSubscribesOfUser, .userSubscribersOfUser, .userSubscribersOfShop:
            return .user
        }
    }
}
