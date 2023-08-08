//
//  AddProductPriceStack.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 07.05.2023.
//

import UIKit
import EasyPeasy

class AddProductPriceStack: UIView {
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 1)
    
    var variantCount = UILabel(font: .lil_14,
                               color: .contrast,
                               alignment: .center,
                               numOfLines: 1)
    
    var editBtn = UIStackView(axis: .horizontal,
                              alignment: .center,
                              spacing: 10,
                              edgeInsets: UIEdgeInsets(hEdges: 14),
                              backgroundColor: .white)
    
    var btnTitle = UILabel(font: .lil_14_b,
                           color: .accent)
    
    var icon = UIImageView(contentMode: .scaleAspectFit,
                           cornerRadius: .zero,
                           image: UIImage(named: "forward")?.withRenderingMode(.alwaysTemplate),
                           backgroundColor: .clear,
                           tintColor: .accent)
    
    var clickCallback: ( ()->() )?
    
    init(btnTitle: String){
        super.init(frame: .zero)
        self.btnTitle.text = btnTitle
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        variantCount.backgroundColor = .white
        backgroundColor = .bg
        layer.cornerRadius = 10
        clipsToBounds = true

        addSubview(contentStack)
        contentStack.easy.layout(Edges())
        variantCount.easy.layout(Height(40))
        editBtn.easy.layout(Height(40))
        icon.easy.layout(Height(20))
        
        contentStack.addArrangedSubviews([variantCount, editBtn])
        editBtn.addArrangedSubviews([btnTitle, UIView(), icon])
    }
    
    func setupCount(count: Int){
        variantCount.text = "variants".localized()+" \(count) "
    }
    
    @objc func click(){
        clickCallback?()
    }
}
