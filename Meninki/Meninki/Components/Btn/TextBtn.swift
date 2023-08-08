//
//  TextBtn.swift
//  Meninki
//
//  Created by Shirin on 3/29/23.
//

import UIKit

class TextBtn: BaseBtn {

    init(title: String){
        super.init(frame: .zero)
        
        setContentHuggingPriority(.required, for: .horizontal)
        setContentHuggingPriority(.required, for: .vertical)
        
        setTitle(title, for: .normal)
        setTitleColor(.oldAccent, for: .normal)
        
        titleLabel?.font = .regular(size: 14)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
