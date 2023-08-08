//
//  AuthRequests.swift
//  Meninki
//
//  Created by Shirin on 3/29/23.
//

import Foundation
import Alamofire

class AuthRequests {
    
    static let shared = AuthRequests()
    
    func sendOtp(number: String, completionHandler: @escaping (Id?)->()){
        
        Network.perform(url: ApiPath.SEND_OTP,
                    method: .post,
                    params: ["phoneNumber":number],
                    encoder: JSONParameterEncoder.default,
                    completionHandler: completionHandler)
    }
    
    func resendOtp(number: String, id: String, completionHandler: @escaping (Id?)->()){
        
        Network.perform(url: ApiPath.SEND_OTP,
                    method: .post,
                    params: ["phoneNumber":number,
                             "id": id],
                    encoder: JSONParameterEncoder.default,
                    completionHandler: completionHandler)
        
    }

    func checkOtp(code: String, completionHandler: @escaping (Token?)->()){
        
        Network.perform(url: ApiPath.CHECK_OTP,
                    method: .post,
                    params: [  "id": AccUserDefaults.id,
                               "phoneConfirmationCode": code],
                    encoder: JSONParameterEncoder.default,
                    completionHandler: completionHandler)
        
    }
    
    func signUpWithGoogle(params: SignInWithApple, completionHandler: @escaping (Token?)->()){
        
        Network.perform(url: ApiPath.REGISTER_APPLE,
                    method: .post,
                    params: params,
                    encoder: JSONParameterEncoder.default,
                    completionHandler: completionHandler)
    }

    func updateUser(params: UpdateUser,
                    completionHandler: @escaping (Bool?)->()){
        
        Network.perform(url: ApiPath.UPDATE_USER,
                    method: .put,
                    params: params,
                    encoder: JSONParameterEncoder.default,
                    completionHandler: completionHandler)
    }
    
    func deleteUser(completionHandler: @escaping (Bool?)->()){
        
        Network.perform(url: ApiPath.DELETE_USER,
                    method: .post,
                    params: ["id": AccUserDefaults.id],
                    encoder: JSONParameterEncoder.default,
                    completionHandler: completionHandler)
    }

}
