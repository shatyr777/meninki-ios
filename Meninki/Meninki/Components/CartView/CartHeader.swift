//
//  CartHeader.swift
//  Meninki
//
//  Created by Shirin on 5/3/23.
//

import UIKit
import EasyPeasy

class CartHeader: UIView {

    var contentStack = UIStackView(axis: .horizontal,
                                   alignment: .fill,
                                   spacing: 10,
                                   edgeInsets: UIEdgeInsets(edges: 20))
    
    var titleStack = UIStackView(axis: .vertical,
                                 alignment: .fill,
                                 spacing: 6)

    var title = UILabel(font: .h2,
                        color: .contrast,
                        text: "cart".localized())
    
    var price = UILabel(font: .lil_14_b,
                       color: .contrast)
    
    var orderBtn: IconBtn = {
        let b = IconBtn(icon: UIImage(named: "order"),
                        tintColor: .white)
        b.layer.cornerRadius = 10
        b.backgroundColor = .contrast
        b.easy.layout(Size(48))
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(contentStack)
        contentStack.easy.layout(Edges())
        
        contentStack.addArrangedSubviews([titleStack, UIView(), orderBtn])
        titleStack.addArrangedSubviews([title, price])
    }
}
