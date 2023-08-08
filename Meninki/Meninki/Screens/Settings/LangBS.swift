//
//  LangBS.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 08.05.2023.
//

import UIKit
import Localize_Swift

class LangBS: UIViewController {

    var didSelect: ( ()->() )?
    
    var mainView: BottomSheetView {
        return view as! BottomSheetView
    }

    var tk = BottomSheetBtn(title: "tk".localized(), icon: nil)
    var ru = BottomSheetBtn(title: "ru".localized(), icon: nil)
    var en = BottomSheetBtn(title: "en".localized(), icon: nil)
    override func loadView() {
        super.loadView()
        view = BottomSheetView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.title.text = "select_lang".localized()
        mainView.desc.text = ""

        setupView()
    }
    
    func setupView(){
        mainView.btnStack.addArrangedSubviews([tk, ru, en])
        
        tk.clickCallback = { [weak self] in
            AccUserDefaults.language = "tk"
            Localize.setCurrentLanguage(AccUserDefaults.language)
            self?.didSelect?()
            self?.dismiss(animated: true)
        }
        
        ru.clickCallback = { [weak self] in
            AccUserDefaults.language = "ru"
            Localize.setCurrentLanguage(AccUserDefaults.language)
            self?.didSelect?()
            self?.dismiss(animated: true)
        }
        
        en.clickCallback = { [weak self] in
            AccUserDefaults.language = "en"
            Localize.setCurrentLanguage(AccUserDefaults.language)
            self?.didSelect?()
            self?.dismiss(animated: true)
        }
    }
}
