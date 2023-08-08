//
//  OtpVM.swift
//  Meninki
//
//  Created by Shirin on 3/29/23.
//

import UIKit

class OtpVM {

    var inProgres: Binder<Bool> = Binder(false)
    var openRegister: Binder<Bool> = Binder(false)
    var openTabbar: Binder<Bool> = Binder(false)

    func checkOtp(code: String){
        inProgres.value = true
        
        AuthRequests.shared.checkOtp(code: code) { [weak self] resp in
            self?.inProgres.value = false

            guard let data = resp else {
                PopUpLauncher.showErrorMessage(text: "smth_went_wrong".localized())
                return
            }
            
            AccUserDefaults.saveToken(data)
            self?.openRegister.value = true
        }
    }
    
    func resendCode(){
        inProgres.value = true

        AuthRequests.shared.sendOtp(number: AccUserDefaults.phone ?? "") { [weak self] resp in
            self?.inProgres.value = false

            guard let id = resp?.id else {
                PopUpLauncher.showErrorMessage(text: "smth_went_wrong".localized())
                return
            }

            print("POPUP SUCCESS ")
        }
    }
}
