//
//  PhoneVM.swift
//  Meninki
//
//  Created by Shirin on 3/29/23.
//

import Foundation
import AuthenticationServices
import GoogleSignIn

class PhoneVM: NSObject {
    
    var inProgres: Binder<Bool> = Binder(false)
    var openOtp: Binder<Bool> = Binder(false)
    var openTabbar: Binder<Bool> = Binder(false)
    var openUsername: Binder<Bool> = Binder(false)
    
    func sendOtp(phone: String){
        
        inProgres.value = true
        
        AuthRequests.shared.sendOtp(number: "993"+phone) { [weak self] resp in
            self?.inProgres.value = false
            
            guard let id = resp?.id else {
                PopUpLauncher.showErrorMessage(text: "smth_went_wrong")
                return
            }
            
            AccUserDefaults.id = id
            AccUserDefaults.phone = "993"+phone
            self?.openOtp.value = true
        }
    }
    
    func signUpWithApple(user: SignInWithApple ){
        
        inProgres.value = true

        AuthRequests.shared.signUpWithGoogle(params: user) { [weak self] resp in
            self?.inProgres.value = false

            guard let data = resp else {
                PopUpLauncher.showErrorMessage(text: "smth_went_wrong")
                return
            }
            
            AccUserDefaults.saveToken(data)
            AccUserDefaults.name = user.fullName
            AccUserDefaults.email = user.email
            self?.openTabbar.value = true
        }
    }
    
    func appleSignIn(delegate: ASAuthorizationControllerPresentationContextProviding?) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = delegate
        authorizationController.performRequests()
    }
    
    func googleSignIn(presenting: UIViewController) {
        GIDSignIn.sharedInstance.signIn( withPresenting: presenting) { signInResult, error in
          
            guard let result = signInResult else {
                PopUpLauncher.showErrorMessage(text: "smth_went_wrong")
                return
            }

            let user = SignInWithApple(userId: result.user.userID ?? "",
                                       fullName: result.user.profile?.name ?? "",
                                       email: result.user.profile?.email ?? "")
            self.signUpWithApple(user: user)
        }
        
        GIDSignIn.sharedInstance.signOut()
    }
}

extension PhoneVM: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let user = SignInWithApple(userId: appleIDCredential.user,
                                       fullName: (appleIDCredential.fullName?.givenName ?? "") + " " + (appleIDCredential.fullName?.familyName ?? ""),
                                       email: appleIDCredential.email ?? "")
            
            signUpWithApple(user: user)
            
        default:
            break
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        debugPrint(error)
    }
}

