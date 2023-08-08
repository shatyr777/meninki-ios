//
//  ProfileDataBlock.swift
//  Meninki
//
//  Created by Shirin on 5/2/23.
//

import UIKit
import EasyPeasy

class ProfileDataBlock: UIView {

    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 6,
                                   edgeInsets: UIEdgeInsets(edges: 14))
    
    var title = UILabel(font: .lil_14,
                        color: .contrast,
                        alignment: .center,
                        numOfLines: 0)
    
    var count = UILabel(font: .sb_16,
                        color: .contrast,
                        alignment: .center,
                        numOfLines: 0)
    
    var clickCallback: ( ()->() )?
    
    init(title: String, axis: NSLayoutConstraint.Axis = .vertical){
        super.init(frame: .zero)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
        self.title.text = title
        contentStack.axis = axis
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        backgroundColor = .white
        layer.cornerRadius = 10
        
        addSubview(contentStack)
        contentStack.easy.layout(Edges())
        contentStack.setContentCompressionResistancePriority(.required, for: .vertical)

        contentStack.addArrangedSubviews([title,
                                          count])
        
    }
    
    func setupCount(_ data: Int?){
        if (data ?? 0) == 0 {
            count.text = "none".localized()
            count.textColor = .textLc
        } else {
            count.text = "\(data ?? 0)"
            count.textColor = .contrast
        }
    }
    
    @objc func click(){
        clickCallback?()
    }
}
