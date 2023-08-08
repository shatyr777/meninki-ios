//
//  EnterTextVC.swift
//  Meninki
//
//  Created by NyanDeveloper on 16.01.2023.
//

import UIKit

class EnterTextVC: UIViewController {

    var img: UIImage?
    
    var mainView: EnterTextView {
        return view as! EnterTextView
    }
        
    override func loadView() {
        super.loadView()
        view = EnterTextView()
        view.backgroundColor = .black.withAlphaComponent(0.3)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        mainView.dismissClickCallback = { [weak self] in
            self?.dismiss(animated: false)
        }
    }
}
