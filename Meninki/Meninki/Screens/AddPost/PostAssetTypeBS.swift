//
//  PostAssetTypeBS.swift
//  Meninki
//
//  Created by Shirin on 5/4/23.
//

import UIKit

class PostAssetTypeBS: UIViewController {
    
    var imageBtn = BottomSheetBtn(title: "images".localized(), icon: UIImage(named: "image"))
   
    var videoBtn = BottomSheetBtn(title: "video".localized(), icon: UIImage(named: "video"))

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
        mainView.title.text = "select_media_type".localized()
        mainView.desc.text = "select_media_type_desc".localized()
        mainView.contentStack.addArrangedSubviews([imageBtn, videoBtn])
    }
}
