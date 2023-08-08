//
//  ApiCall.swift
//  BaseApp
//
//  Created by Shirin on 3/24/23.
//

import Foundation
import Alamofire

class Network {
    
    class func perform<T:Decodable, Parameter: Encodable> (
        url: String,
        method: HTTPMethod = .get,
        params: Parameter,
        encoder: ParameterEncoder = URLEncodedFormParameterEncoder.default,
        headers: HTTPHeaders = [
            .contentType("application/json"),
            .authorization(bearerToken: AccUserDefaults.token)
        ],
        completionHandler: @escaping (T?)->() ){
           AF.request(url,
                      method: method,
                      parameters: params,
                      encoder: encoder,
                      headers: headers)
           .responseDecodable(of: T.self) { resp in

               debugPrint(resp)
               
            guard let value = resp.value else {
                completionHandler(nil)
                return
            }

               
            completionHandler(value)
        }
    }
    
    
    class func addImages(images: [UploadImage],
                         objectId: String? = nil,
                         progressCallback: ( (Float)->() )? = nil, 
                         completionHandler: @escaping (Bool?)->() ) {
        
        print(images)
        
        AF.upload(multipartFormData: { formdata in
            
            images.enumerated().forEach { (ind, img) in
                let prefix = "Images[\(ind)]."

                formdata.append(img.data ?? Data(),
                                withName: prefix+"Image",
                                fileName: img.filename)
                
                formdata.append("\(img.isAvatar)".data(using: String.Encoding.utf8)!,
                                withName: prefix+"IsAvatar")
                formdata.append("\(img.imageType)".data(using: String.Encoding.utf8)!,
                                withName: prefix+"ImageType")
                formdata.append("\(img.width ?? 0)".data(using: String.Encoding.utf8)!,
                                withName: prefix+"Width")
                formdata.append("\(img.height ?? 0)".data(using: String.Encoding.utf8)!,
                                withName: prefix+"Height")
                
                formdata.append( (objectId ?? img.objectId).data(using: String.Encoding.utf8)!,
                                withName: prefix+"ObjectId")
            }
            
        }, to: ApiPath.UPLOAD_IMG,
                  headers: [
                    .authorization(bearerToken: AccUserDefaults.token)
                  ]).uploadProgress(queue: .main, closure: { progress in
                      let progress = Float(progress.fileCompletedCount ?? 1)/Float(progress.fileTotalCount ?? 1)
                      progressCallback?(progress)
                  })
        .responseDecodable(of: Bool.self) { resp in
            debugPrint(resp)
            completionHandler(resp.value)
        }
    }
}
