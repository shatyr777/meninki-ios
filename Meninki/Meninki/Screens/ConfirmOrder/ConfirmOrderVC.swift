//
//  ConfirmOrderVC.swift
//  Meninki
//
//  Created by Shirin on 5/3/23.
//

import UIKit

class ConfirmOrderVC: UIViewController {

    var viewModel = ConfirmOrderVM()
    
    var mainView: ConfirmOrderView {
        return view as! ConfirmOrderView
    }

    override func loadView() {
        super.loadView()
        view = ConfirmOrderView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.addObserver()
        hideKeyboardWhenTappedAround()
        
        setupBindings()
        setupCallbacks()
    }
    
    func setupBindings(){
        viewModel.inProgress.bind { [weak self] toShow in
            self?.mainView.loading(toShow)
        }
        
        viewModel.success.bind { [weak self] success in
            if success == true {
                PopUpLauncher.showSuccessMessage(text: "successfully_ordered".localized())
                CartTabVC.update = true
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func setupCallbacks(){
        mainView.header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        mainView.address.clickCallback = { [weak self] in
            let vc = SelectAddresVC()
            vc.selectedAddress = { [weak self] address in
                self?.mainView.address.textField.text = address
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        mainView.doneBtn.clickCallback = { [weak self] in
            guard let params = self?.getData() else { return }
            self?.viewModel.order(params: params)
        }
    }
    
    func getData() -> OrderProduct? {
        guard let name = mainView.name.getValue() else { return nil }
        guard let phone = mainView.phone.isValidPhone() else { return nil }
        guard let address = mainView.address.getValue() else { return nil }
        return OrderProduct(firstName: name,
                            lastName: "",
                            adress: address,
                            phoneNumber: phone)
    }
}
