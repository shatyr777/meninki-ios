//
//  ProductRequests.swift
//  Meninki
//
//  Created by Shirin on 4/24/23.
//

import Foundation
import Alamofire

class ProductRequests {
    
    static let shared = ProductRequests()
    
    func getCategories(completionHandler: @escaping ([Category]?)->() ){
        
        Network.perform(url: ApiPath.GET_CATEGORIES,
                        params: Empty(),
                        completionHandler: completionHandler)
    }
    
    func getProducts(params: GetCard,
                     completionHandler: @escaping ([Card]?)->() ){
        var params = params
        params.categoryIds?.removeAll(where: {$0 == ""})
        if params.categoryIds?.isEmpty == true { params.categoryIds = nil }
        Network.perform(url: ApiPath.GET_PRODUCTS,
                        method: .post,
                        params: params,
                        encoder: JSONParameterEncoder.default,
                        completionHandler: completionHandler)
    }
    
    func getProduct(id: String, completionHandler: @escaping (Product?)->() ){
        
        Network.perform(url: ApiPath.GET_ONE_PRODUCT+id,
                        params: Empty(),
                        completionHandler: completionHandler)
    }

    
    func getHome(page: String, completionHandler: @escaping ([Home]?)->()) {
        Network.perform(url: ApiPath.GET_HOME+page,
                        params: Empty(),
                        completionHandler: completionHandler)
    }

    func getInCart(completionHandler: @escaping ([Cart]?)->() ){
        
        Network.perform(url: ApiPath.GET_IN_CART,
                    method: .post,
                        params: ["orderStatus": 0],
                    encoder: JSONParameterEncoder.default,
                    completionHandler: completionHandler)
    }

    func addToCart(params: AddToCart,
                   completionHandler: @escaping (Bool?)->() ){
        
        Network.perform(url: ApiPath.ADD_TO_CART,
                    method: .post,
                    params: params,
                    encoder: JSONParameterEncoder.default,
                    completionHandler: completionHandler)
    }

    func orderProducts(params: OrderProduct,
                       completionHandler: @escaping (Bool?)->() ){
        
        Network.perform(url: ApiPath.BUY_PRODUCT,
                        method: .post,
                        params: params,
                        encoder: JSONParameterEncoder.default,
                        completionHandler: completionHandler)
    }

    func getShopOrders(params: GetOrders,
                       completionHandler: @escaping ([ShopOrder]?)->()){
        
        Network.perform(url: ApiPath.GET_SHOP_ORDERS,
                        method: .post,
                        params: params,
                        encoder: JSONParameterEncoder.default,
                        completionHandler: completionHandler)
    }
    
    func changeOrderStatus(params: ChangeOrder,
                           completionHandler: @escaping (Bool?)->() ){
        
        Network.perform(url: ApiPath.CHANGE_ORDER_STATUS,
                        method: .post,
                        params: params,
                        encoder: JSONParameterEncoder.default,
                        completionHandler: completionHandler)

    }
}
