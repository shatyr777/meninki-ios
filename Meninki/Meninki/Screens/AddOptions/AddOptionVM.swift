//
//  AddOptionVM.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 06.05.2023.
//

import Foundation

class AddOptionsVM {
    
    var productId = ""
    
    var inProgress: Binder<Bool> = Binder(false)
    var personalChars: Binder<[PersonalCharacteristics]?> = Binder(nil)
    var optionsAdded: Binder<Bool> = Binder(false)
    var imgAdded: Binder<Bool> = Binder(false)
    
    
    func addOptions(params: AddOptions){
        if inProgress.value == true { return }
        inProgress.value = true

        AddRequests.shared.createOptions(params: params) {[weak self] resp in
            self?.inProgress.value = false

            if resp == nil {
                PopUpLauncher.showErrorMessage(text: "smth_went_wrong".localized())
                return
            }
            
            self?.optionsAdded.value = true
        }
    }
    
    func addImages(images: [UploadImage]){
        if inProgress.value == true { return }
        inProgress.value = true

        Network.addImages(images: images) { [weak self] resp in
            self?.inProgress.value = false

            if resp != true {
                PopUpLauncher.showErrorMessage(text: "smth_went_wrong".localized())
                return
            }
            
            self?.imgAdded.value = true
        }
    }
    
    func getPersonalChars(){
        if inProgress.value == true { return }
        inProgress.value = true

        AddRequests.shared.getPersonalChars(id: productId) { [weak self] resp in
            self?.inProgress.value = false

            if resp == nil {
                PopUpLauncher.showErrorMessage(text: "smth_went_wrong".localized())
                return
            }
            
            self?.personalChars.value = resp ?? []
        }
    }
}
