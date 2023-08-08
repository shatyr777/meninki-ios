//
//  Stepper.swift
//  Meninki
//
//  Created by Shirin on 5/3/23.
//

import UIKit
import EasyPeasy

class Stepper: UIView {

    var contentStack = UIStackView(axis: .horizontal,
                                   alignment: .fill,
                                   spacing: 0)
    
    var minusBtn: IconBtn = {
        let b = IconBtn(icon: UIImage(named: "minus"))
        b.easy.layout(Size(32))
        return b
    }()

    var countLbl = UILabel(font: .sb_16, color: .contrast)
    
    var plusBtn: IconBtn = {
        let b = IconBtn(icon: UIImage(named: "plus"))
        b.easy.layout(Size(32))
        return b
    }()

    var count = 0 {
        didSet {
            if count < 0 { count = 0 }
            countLbl.text = "\(count)"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        backgroundColor = .white
        layer.cornerRadius = 16
        
        addSubview(contentStack)
        contentStack.easy.layout(Edges())
        
        contentStack.setContentHuggingPriority(.required, for: .horizontal)
        countLbl.setContentHuggingPriority(.required, for: .horizontal)
        countLbl.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        contentStack.addArrangedSubviews([minusBtn,
                                          countLbl,
                                          plusBtn])
    }
}
