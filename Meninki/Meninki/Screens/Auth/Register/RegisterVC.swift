//
//  RegisterVC.swift
//  Meninki
//
//  Created by Shirin on 3/29/23.
//

import UIKit

class RegisterVC: UIViewController {

    let viewModel = RegisterVM()
    
    var mainView: RegisterView {
        return view as! RegisterView
    }
    
    override func loadView() {
        super.loadView()
        view = RegisterView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.addObserver()
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
    }

    func setupCallbacks(){
        mainView.header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        mainView.doneBtn.clickCallback = { [weak self] in
            guard let user = self?.getData() else { return }
            self?.viewModel.registerUser(user: user)
        }
    }
    
    func getData() -> UpdateUser? {
        guard let name = mainView.nameTextField.getValue() else { return nil }
        guard let userName = mainView.usernameTextField.isValidUsername() else { return nil }
        return UpdateUser(userName: userName, firstName: name)
    }
    
    func openTabbar(){
        navigationController?.setViewControllers([TabbarVC()], animated: true)
    }
}
