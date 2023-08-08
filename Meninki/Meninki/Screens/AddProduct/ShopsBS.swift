//
//  ShopsBS.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 07.05.2023.
//

import UIKit

class ShopsBS: UIViewController {

    let shops = AccUserDefaults.shops
    let shopIds = AccUserDefaults.shopIds

    var didSelectShop: ( (User)->() )?
    
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
        mainView.title.text = "select_shop_title".localized()
        mainView.desc.text = "select_shop_desc".localized()

        setupView()
    }
    
    func setupView(){
        shops.enumerated().forEach { (ind, shopName) in
            let shop = User(id: shopIds[ind], name: shopName)
            let b = BottomSheetBtn(title: shopName, icon: nil)
            b.clickCallback = { [weak self] in
                self?.didSelectShop?(shop)
                self?.dismiss(animated: true)
            }
            
            mainView.btnStack.addArrangedSubview(b)
        }
    }
}
