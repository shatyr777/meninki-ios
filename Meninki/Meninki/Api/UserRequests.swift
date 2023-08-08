//
//  UserRequests.swift
//  Meninki
//
//  Created by Shirin on 4/24/23.
//

import Foundation
import Alamofire

class UserRequests {
    
    static let shared = UserRequests()
    
    func getUserList(type: SubscriberListType,
                     params: GetSubscribers,
                     completionHandler: @escaping ([User]?)->() ){
        
        Network.perform(url: type.path,
                        method: .post,
                        params: params,
                        encoder: JSONParameterEncoder.default,
                        completionHandler: completionHandler)
    }
    
    func getUserProfile(id: String,
                        completionHandler: @escaping (UserProfile?)->() ){
        
        Network.perform(url: ApiPath.GET_USER_PROFILE+"\(id)",
                        params: Empty(),
                        completionHandler: completionHandler)
    }
    
    
    func getShopProfile(id: String,
                        completionHandler: @escaping (UserProfile?)->() ){
        
        Network.perform(url: ApiPath.GET_SHOP_PROFILE+"\(id)",
                        params: Empty(),
                        completionHandler: completionHandler)
    }
    
    func addShop(params: AddShop, completionHandler: @escaping (UserProfile?)->()){
       
        Network.perform(url: ApiPath.ADD_SHOP,
                        method: params.id == nil ? .post : .put ,
                        params: params,
                        encoder: JSONParameterEncoder.default,
                        completionHandler: completionHandler)
    }
    
    func changeUserSubscribeStatus(params: ChangeLike,
                                   completionHandler: @escaping (Bool?)->() ){
        
        Network.perform(url: ApiPath.CHANGE_USER_SUBSCRIPTION,
                        method: .post,
                        params: params,
                        encoder: JSONParameterEncoder.default,
                        completionHandler: completionHandler)
    }
    
    func changeShopSubscribeStatus(params: ChangeLike,
                                   completionHandler: @escaping (Bool?)->() ){
        
        Network.perform(url: ApiPath.CHANGE_SHOP_SUBSCRIPTION,
                        method: .post,
                        params: params,
                        encoder: JSONParameterEncoder.default,
                        completionHandler: completionHandler)
    }
}
