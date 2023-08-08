//
//  OtpVC.swift
//  Meninki
//
//  Created by Shirin on 3/29/23.
//

import UIKit

class OtpVC: UIViewController {
    
    let viewModel = OtpVM()
    
    var mainView: OtpView {
        return view as! OtpView
    }
    
    override func loadView() {
        super.loadView()
        view = OtpView()
        view.backgroundColor = .bg
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupCallbacks()
    }
    
    func setupBindings(){
        viewModel.inProgres.bind { [weak self] toShow in
            self?.mainView.loading(toShow)
            if toShow {
                self?.mainView.stopTimer()
            } else {
                self?.mainView.startTimer()
            }
        }
        
        viewModel.openTabbar.bind { [weak self] toShow in
            if !toShow { return }
            self?.openTabbar()
        }
        
        viewModel.openRegister.bind { [weak self] toShow in
            if !toShow { return }
            self?.openRegister()
        }
    }
    
    func setupCallbacks(){
        mainView.otpField.didReceiveCode = { [weak self] code in
            self?.viewModel.checkOtp(code: code)
        }
        
        mainView.resenBtn.clickCallback = { [weak self] in
            self?.viewModel.resendCode()
        }
    }
    
    func openTabbar(){
        navigationController?.setViewControllers([TabbarVC()], animated: true)
    }

    func openRegister(){
        navigationController?.pushViewController(RegisterVC(), animated: true)
    }
}
