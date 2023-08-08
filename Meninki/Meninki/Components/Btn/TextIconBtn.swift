//
//  TextIconBtn.swift
//  Meninki
//
//  Created by Shirin on 3/29/23.
//

import UIKit

class TextIconBtn: UIStackView {

    var title = UILabel(font: .lil_14,
                        color: .contrast,
                        alignment: .left,
                        numOfLines: 0)
    
    var icon = UIImageView(contentMode: .center,
                           cornerRadius: .zero,
                           backgroundColor: .clear)
    
    var bg = UIView()
    
    var clickCallback: ( ()->() )?
    
    init(title: String, icon: UIImage?){
        super.init(frame: .zero)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
        setupView()
        self.title.text = title
        self.icon.image = icon
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        spacing = 10
        alignment = .center
        
        bg = addBackground(color: .lowContrast,
                           cornerRadius: 22)
        
        addMargins(insets: UIEdgeInsets(hEdges: 24, vEdges: 10))
        
        icon.setContentHuggingPriority(.required, for: .horizontal)
        icon.setContentHuggingPriority(.required, for: .vertical)
        addArrangedSubviews([title, icon])
    }
    
    func makeContrast(){
        bg.backgroundColor = .contrast
        icon.tintColor = .white
        title.textColor = .white
    }
    
    @objc func click(){
        clickCallback?()
    }
}
