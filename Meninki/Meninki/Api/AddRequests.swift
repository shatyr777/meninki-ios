//
//  AddRequests.swift
//  Meninki
//
//  Created by Shirin on 5/4/23.
//

import Foundation
import Alamofire

class AddRequests {
    static let shared = AddRequests()
    

    func addPost(params: AddPost, completionHandler: @escaping (String?)->() ){
        Network.perform(url: ApiPath.ADD_POST,
                        method: .post,
                        params: params,
                        encoder: JSONParameterEncoder.default,
                        completionHandler: completionHandler)
    }

    func addVideo(video: UploadVideo,
                  objectId: String,
                  progressCallback: ( (Float)->() )?,
                  completionHandler: @escaping (Bool?)->() ) {
        
        print(video)
        AF.upload(multipartFormData: { formdata in
            formdata.append(video.data ?? Data(),
                            withName: "Video",
                            fileName: video.filename,
                            mimeType: video.filename.mimeType())
            
            formdata.append("0".data(using: String.Encoding.utf8)!,
                            withName:"VideoType")
            
            formdata.append("\(video.vertical)".data(using: String.Encoding.utf8)!,
                            withName: "Vertical")
            
            formdata.append(objectId.data(using: String.Encoding.utf8)!,
                            withName: "ObjectId")

            formdata.append(video.imgData ?? Data(),
                            withName: "Preview",
                            fileName: "img.jpeg",
                            mimeType: "img.jpeg".mimeType())

            formdata.append("\(video.width ?? 0)".data(using: String.Encoding.utf8)!,
                            withName: "Width")
            
            formdata.append("\(video.height ?? 0)".data(using: String.Encoding.utf8)!,
                            withName: "Height")
            
        }, to: ApiPath.UPLOAD_VIDEO, 
                  headers: [
                    .authorization(bearerToken: AccUserDefaults.token)
                  ]) .uploadProgress(queue: .main, closure: { progress in
                      let progress = Float(progress.fileCompletedCount ?? 1)/Float(progress.fileTotalCount ?? 1)
                      progressCallback?(progress)
                  })
        .responseDecodable(of: Bool.self) { resp in
            debugPrint(resp)
            completionHandler(resp.value)
        }
    }


    func addProduct(toAdd: Bool,
                    params: AddProduct,
                    completionHandler: @escaping (Bool?)->() ){

        Network.perform(url: toAdd ? ApiPath.ADD_PRODUCT : ApiPath.UPDATE_PRODUCT,
                        method: toAdd ? .post : .put,
                        params: params,
                        encoder: JSONParameterEncoder.default,
                        completionHandler: completionHandler)
    }

    func createOptions(params: AddOptions,
                       completionHandler: @escaping ([PersonalCharacteristics]?)->() ){

        Network.perform(url: ApiPath.ADD_OPTIONS,
                        method: .post,
                        params: params,
                        encoder: JSONParameterEncoder.default,
                        completionHandler: completionHandler)
    }

    func addPrices(prices: [PersonalCharacteristics], completionHandler: @escaping (Bool?)->() ){

        Network.perform(url: ApiPath.ADD_CHARS,
                    method: .put,
                    params: ["personalCharacteristics": prices],
                    encoder: JSONParameterEncoder.default,
                    completionHandler: completionHandler)
    }

    func getPersonalChars(id: String, completionHandler: @escaping ([PersonalCharacteristics]?)->() ){

        Network.perform(url: ApiPath.GET_CHARS,
                        params: ["productId": id],
                        completionHandler: completionHandler)
    }


}
