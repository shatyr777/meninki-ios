//
//  SettingsView.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 08.05.2023.
//

import UIKit
import EasyPeasy

class SettingsView: BaseView {

    var header = Header(title: "settings".localized())

    var scrollView = ScrollView(spacing: 10,
                                edgeInsets: UIEdgeInsets(edges: 14))

    var changeLang = BottomSheetBtn(title: "change_lang".localized(), icon: UIImage(named: "globe"))
    
    var logout = BottomSheetBtn(title: "logout".localized(), icon: UIImage(named: "logout"))
    
    var deleteAcc = BottomSheetBtn(title: "delete_acc".localized(), icon: nil)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(header)
        header.easy.layout([
            Top(), Leading(), Trailing(),
        ])
        
        addSubview(scrollView)
        scrollView.easy.layout([
            Top().to(header, .bottom), Leading(), Trailing(), Bottom().to(safeAreaLayoutGuide, .bottom)
        ])
        
        scrollView.contentStack.addArrangedSubviews([changeLang,
                                                     logout,
                                                     deleteAcc])
    }
    
    func changeTitles(){
        header.title.text = "settings".localized()
        changeLang.title.text = "change_lang".localized()
        logout.title.text = "logout".localized()
        deleteAcc.title.text = "delete_acc".localized()
    }
}
