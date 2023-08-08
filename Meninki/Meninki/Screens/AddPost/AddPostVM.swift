//
//  AddPostVM.swift
//  Meninki
//
//  Created by Shirin on 5/1/23.
//

import Foundation

class AddPostVM {
//    var tabbar
    var productId: String!
    var postId: String = ""
    
    var uploadVideo: UploadVideo?
    var uploadImg: [UploadImage] = []
    
    var inProgress: Binder<Bool> = Binder(false)
    
    var postAdded: Binder<Bool?> = Binder(false)
    var mediaAdded: Binder<Bool?> = Binder(false)

    func addPost(params: AddPost){
        if postId.isEmpty == false {
            addImages()
            return
        }
        
        inProgress.value = true
        
        AddRequests.shared.addPost(params: params) { [weak self] id in
            self?.inProgress.value = false
            if id != nil {
                self?.postId = id ?? ""
                self?.postAdded.value = true
            } else {
                PopUpLauncher.showErrorMessage(text: "smth_went_wrong".localized())
            }
        }
    }
    
    func addImages(){
        
        inProgress.value = true
        if uploadVideo == nil {
            Network.addImages(images: uploadImg, objectId: postId) { [weak self] resp in
                if resp != nil {
                    self?.inProgress.value = false
                    self?.mediaAdded.value = true
                }
            }
        } else {
            guard let uploadVideo = uploadVideo else { return }
        
            AddRequests.shared.addVideo(video: uploadVideo, objectId: postId) { progress in
                print("progress ", progress)
            } completionHandler: { [weak self] resp in
                if resp != nil {
                    self?.inProgress.value = false
                    self?.mediaAdded.value = true
                }
            }
        }
    }
}
