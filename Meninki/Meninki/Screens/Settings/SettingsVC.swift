//
//  SettingsVC.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 08.05.2023.
//

import UIKit

class SettingsVC: UIViewController {
    
    let sheetTransitioningDelegate = SheetTransitioningDelegate()

    var mainView: SettingsView {
        return view as! SettingsView
    }

    override func loadView() {
        super.loadView()
        view = SettingsView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCallbacks()
    }
    
    func setupCallbacks(){
        mainView.changeLang.clickCallback = { [weak self] in
            self?.openLangBS()
        }
        
        mainView.deleteAcc.clickCallback = { [weak self] in
            self?.confirmDeletion()
        }
        
        mainView.logout.clickCallback = { [weak self] in
            self?.confirmLogout()
        }
    }
    
    func openLangBS(){
        let vc = LangBS()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = sheetTransitioningDelegate
        vc.didSelect = { [weak self] in
            self?.mainView.changeTitles()
            self?.reloadTabbar()
        }
        
        present(vc, animated: true)
    }
    
    func reloadTabbar(){
        guard let vc = navigationController?.viewControllers.first as? TabbarVC else { return }
        vc.setupVc()
    }
    
    func confirmLogout(){
        let alert = UIAlertController(title: "logout_title".localized(), message: "logout_decs".localized(), preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "yes".localized(), style: .default, handler: { _ in
            AccUserDefaults.clear()
            self.navigationController?.setViewControllers([PhoneVC()], animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "no".localized(), style: .destructive, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    func confirmDeletion(){
        let alert = UIAlertController(title: "delete_acc_title".localized(), message: "delete_acc_desc".localized(), preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "yes".localized(), style: .default, handler: { _ in
            self.deleteUser()
        }))
        
        alert.addAction(UIAlertAction(title: "no".localized(), style: .destructive, handler: nil))

        present(alert, animated: true, completion: nil)
    }
}

extension SettingsVC {
    func deleteUser(){
        AuthRequests.shared.deleteUser { [weak self] resp in
            if resp == true {
                AccUserDefaults.clear()
                self?.navigationController?.setViewControllers([PhoneVC()], animated: true)
            } else {
                PopUpLauncher.showErrorMessage(text: "smth_went_wrong".localized())
            }
        }
    }
}
