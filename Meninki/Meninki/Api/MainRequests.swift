//
//  MainRequests.swift
//  Meninki
//
//  Created by Shirin on 4/1/23.
//

import Foundation
import Alamofire

class MainRequests {
    
    static let shared = MainRequests()
    
    func getPosts(params: GetCard,
                 completionHandler: @escaping ([Post]?)->() ){
        var params = params
        params.categoryIds?.removeAll(where: {$0 == ""})
        Network.perform(url: ApiPath.GET_POSTS,
                        method: .post,
                        params: params,
                        encoder: JSONParameterEncoder.default,
                        completionHandler: completionHandler)
    }
    
    func likePostProduct(params: ChangeLike,
                  completionHandler: @escaping (Rating?)->() ){
        
        Network.perform(url: ApiPath.LIKE_POST,
                        method: .patch,
                        params: params,
                        encoder: JSONParameterEncoder.default,
                        completionHandler: completionHandler)
    }
}
