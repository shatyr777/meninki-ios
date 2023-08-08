//
//  OptionsBS.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 06.05.2023.
//

import UIKit

class OptionsBS: UIViewController {

    let textBtn = BottomSheetBtn(title: "text", icon: UIImage(named: "text"))
    let imgBtn = BottomSheetBtn(title: "image", icon: UIImage(named: "image"))

    var mainView: BottomSheetView {
        return view as! BottomSheetView
    }

    override func loadView() {
        super.loadView()
        view = BottomSheetView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        mainView.title.text = "option_selection_title".localized()
        mainView.desc.text = "option_selection_desc".localized()
        
        mainView.btnStack.addArrangedSubviews([textBtn,
                                               imgBtn])
    }
}
