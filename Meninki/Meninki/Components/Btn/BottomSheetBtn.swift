//
//  BottomSheetBtn.swift
//  Meninki
//
//  Created by Shirin on 4/22/23.
//

import UIKit

class BottomSheetBtn: UIStackView {
    
    var title = UILabel(font: .lil_14,
                        color: .contrast,
                        alignment: .left,
                        numOfLines: 0)
    
    var icon = UIImageView(contentMode: .center,
                           cornerRadius: .zero,
                           backgroundColor: .clear)
    
    var spacer = UIView()
    
    var clickCallback: ( ()->() )?
    
    init(title: String, icon: UIImage?){
        super.init(frame: .zero)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
        setupView()
        self.title.text = title
        self.icon.image = icon?.withRenderingMode(.alwaysTemplate)
        self.icon.tintColor = .contrast
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        spacing = 10
        alignment = .center
        
        let _ = addBackground(color: .onBgLc,
                              cornerRadius: 14)
        addMargins(insets: UIEdgeInsets(hEdges: 20, vEdges: 16))
        
        icon.setContentHuggingPriority(.required, for: .horizontal)
        icon.setContentHuggingPriority(.required, for: .vertical)
        addArrangedSubviews([title,
                             spacer,
                             icon])
    }
    
    @objc func click(){
        clickCallback?()
    }
}
