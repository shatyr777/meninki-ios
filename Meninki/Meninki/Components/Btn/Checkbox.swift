//
//  Checkbox.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 06.05.2023.
//

import Foundation
import EasyPeasy

class Checkbox: UIImageView {

//    let img = UIImageView(contentMode: .center,
//                          cornerRadius: .zero,
//                          backgroundColor: .clear)
    
    var checked = false {
        didSet {
            changeStatus()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        image = UIImage(named: "check-unselected")
        
        layer.cornerRadius = 4
        easy.layout(Height(20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeStatus(){
        image = UIImage(named: checked ? "check-selected" : "check-unselected")
    }
}
