//
//  PhoneVC.swift
//  Meninki
//
//  Created by Shirin on 3/29/23.
//

import UIKit
import AuthenticationServices
import Localize_Swift

class PhoneVC: UIViewController {

    let viewModel = PhoneVM()
    
    var mainView: PhoneView {
        return view as! PhoneView
    }

    override func loadView() {
        super.loadView()
        view = PhoneView()
        view.backgroundColor = .bg
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        hideKeyboardWhenTappedAround()
        
        setupBindings()
        setupCallbacks()
    }

    func setupBindings(){
        viewModel.inProgres.bind { [weak self] toShow in
            self?.mainView.loading(toShow)
        }
        
        viewModel.openTabbar.bind { [weak self] toShow in
            if !toShow { return }
            self?.openTabbar()
        }
        
        viewModel.openOtp.bind { [weak self] toShow in
            if !toShow { return }
            self?.openOtp()
        }
    }
    
    func setupCallbacks(){
        mainView.langBtn.clickCallback = { [weak self] in
            let vc = SelectLangVC()
            vc.data = ["ru", "en", "tm"]
            vc.didSelectAtInd = { [weak self] ind in
                AccUserDefaults.language = vc.data[ind]
                Localize.setCurrentLanguage(AccUserDefaults.language)
                self?.mainView.setupText()
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        mainView.doneBtn.clickCallback = { [weak self] in
            guard let phone = self?.mainView.phoneTextField.isValidPhone() else { return }
            self?.viewModel.sendOtp(phone: phone)
        }
        
        mainView.signInWithApple.clickCallback = { [weak self] in
            guard let s = self else { return }
            s.viewModel.appleSignIn(delegate: s)
        }
        
        mainView.signInWithGoogle.clickCallback = { [weak self] in
            guard let s = self else { return }
            s.viewModel.googleSignIn(presenting: s)
        }
    }
    
    func openTabbar(){
        navigationController?.setViewControllers([TabbarVC()], animated: true)
    }
    
    func openOtp(){
        navigationController?.pushViewController(OtpVC(), animated: true)
    }
}

extension PhoneVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
