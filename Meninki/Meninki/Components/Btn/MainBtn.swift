//
//  MainBtn.swift
//  Meninki
//
//  Created by Shirin on 3/28/23.
//

import UIKit
import EasyPeasy

class MainBtn: BaseBtn {
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = .contrast
            } else {
                backgroundColor = .onBgLc
            }
        }
    }
    
    init(title: String, isActive: Bool = true){
        super.init(frame: .zero)
        titleLabel?.font = .lil_14_b
        setTitle(title, for: .normal)
        setTitleColor(.neutralDark, for: .disabled)
        setTitleColor(.bg, for: .normal)
        layer.cornerRadius = 23
        easy.layout(Height(46))
        
        isEnabled = isActive
        if isEnabled {
            backgroundColor = .accent
        } else {
            backgroundColor = .onBgLc
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
