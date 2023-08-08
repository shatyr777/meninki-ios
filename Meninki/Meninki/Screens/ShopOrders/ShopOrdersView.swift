//
//  ShopOrdersView.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 08.05.2023.
//

import UIKit
import EasyPeasy

class ShopOrdersView: UIView {
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 10)
    
    var header = Header(title: "shop_orders".localized())
    
    var optionsView = CategoryBtnView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(contentStack)
        contentStack.easy.layout([
            Top(), Leading(), Trailing(), Bottom().to(safeAreaLayoutGuide, .bottom)
        ])

        contentStack.addArrangedSubviews([header, optionsView])
    }
    
    func setupData(){
        optionsView.data = [Category(id: "",
                                     nameRu: "ordered_products".localized(),
                                     nameTm: "ordered_products".localized(),
                                     nameEn: "ordered_products".localized()),
                            
                            Category(id: "",
                                     nameRu: "delivered_products".localized(),
                                     nameTm: "delivered_products".localized(),
                                     nameEn: "delivered_products".localized())]
    }
}
