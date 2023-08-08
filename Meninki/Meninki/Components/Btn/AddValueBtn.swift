//
//  AddValueBtn.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 07.05.2023.
//

import UIKit
import EasyPeasy

class AddValueBtn: UIView {

    let contentStack = UIStackView(axis: .horizontal,
                                   alignment: .center,
                                   spacing: 10,
                                   distribution: .fillProportionally)
    
    let icon = UIImageView(contentMode: .scaleAspectFill,
                           cornerRadius: 0,
                           image: UIImage(named: "plus-filled"),
                           backgroundColor: .clear)
    
    let title = UILabel(font: .lil_14,
                        color: .contrast,
                        alignment: .center,
                        text: "add".localized())
    
    var clickCallback: ( ()->() )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        backgroundColor = .lowContrast
        layer.cornerRadius = 10
        
        addSubview(contentStack)
        contentStack.easy.layout(Edges())
        
        icon.easy.layout(Size(20))
        title.setContentHuggingPriority(.required, for: .vertical)
        
        contentStack.addArrangedSubviews([icon, title])
    }
    
    @objc func click(){
        clickCallback?()
    }
}
