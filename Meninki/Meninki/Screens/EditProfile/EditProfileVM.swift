//
//  EditProfileVM.swift
//  Meninki
//
//  Created by Shirin on 5/4/23.
//

import Foundation

class EditProfileVM {
    
    var uploadImg: UploadImage?
    
    var inProgress: Binder<Bool> = Binder(false)
    var success: Binder<Bool> = Binder(false)

    func updateProfile(params: UpdateUser){
        inProgress.value = true
        
        AuthRequests.shared.updateUser(params: params) { [weak self] resp in
            self?.inProgress.value = false

            if resp == true {
                if self?.uploadImg == nil {
                    self?.success.value = true
                } else {
                    self?.addImage()
                }
                
            } else {
                PopUpLauncher.showErrorMessage(text: "smth_went_wrong".localized())
            }
            
        }
    }
    
    func addImage(){
        inProgress.value = true

        Network.addImages(images: [uploadImg!]) { [weak self] resp in
            self?.inProgress.value = false
            if resp == true {
                self?.success.value = true
            } else {
                PopUpLauncher.showErrorMessage(text: "smth_went_wrong".localized())
            }
        }
    }
}
