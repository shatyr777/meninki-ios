//
//  RegisterVM.swift
//  Meninki
//
//  Created by Shirin on 3/29/23.
//

import Foundation

class RegisterVM {
    
    var inProgres: Binder<Bool> = Binder(false)
    var openTabbar: Binder<Bool> = Binder(false)

    func registerUser(user: UpdateUser){
        
        inProgres.value = true
        
        AuthRequests.shared.updateUser(params: user) { [weak self] resp in
            self?.inProgres.value = false
            
            guard let resp = resp else {
                PopUpLauncher.showErrorMessage(text: "smth_went_wrong")
                return
            }

            self?.openTabbar.value = resp
        }
    }
}
