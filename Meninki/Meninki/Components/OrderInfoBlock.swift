//
//  OrderInfoBlock.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 08.05.2023.
//

import UIKit
import EasyPeasy

class OrderInfoBlock: UIView {
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 6,
                                   edgeInsets: UIEdgeInsets(edges: 14))
    
    var title = UILabel(font: .lil_14,
                        color: .contrast,
                        alignment: .left,
                        numOfLines: 0)
    
    var count = UILabel(font: .sb_16,
                        color: .contrast,
                        alignment: .left,
                        numOfLines: 0)
    
    var clickCallback: ( ()->() )?
    
    init(title: String, axis: NSLayoutConstraint.Axis = .vertical){
        super.init(frame: .zero)
        self.title.text = title
        contentStack.axis = axis
        count.textAlignment = axis == .vertical ? .left : .right
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        backgroundColor = .onBgLc
        layer.cornerRadius = 10
        
        addSubview(contentStack)
        contentStack.easy.layout(Edges())
        contentStack.setContentCompressionResistancePriority(.required, for: .vertical)

        contentStack.addArrangedSubviews([title,
                                          count])
        
    }
    
    func setupValue(data: String?){
        count.text = data
    }
}
