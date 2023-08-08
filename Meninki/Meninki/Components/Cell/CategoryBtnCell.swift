//
//  CategoryBtnCell.swift
//  Meninki
//
//  Created by Shirin on 4/1/23.
//

import UIKit
import EasyPeasy

class CategoryBtnCell: UICollectionViewCell {
 
    static let id = "CategoryBtnCell"
    
    var bg = UIView()
    
    var name = UILabel(font: .lil_14,
                       color: .bg,
                       alignment: .center,
                       numOfLines: 1,
                       text: "sdsd")
    
    override var isSelected: Bool {
        didSet {
            bg.backgroundColor = isSelected ? .contrast : .lowContrast
            name.textColor = isSelected ? .bg : .textLc
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        bg.backgroundColor = .lowContrast
        name.textColor = .textLc
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        contentView.addSubview(bg)
        bg.layer.cornerRadius = 20
        bg.easy.layout([
            Edges(), Height(40)
        ])
        
        bg.addSubview(name)
        name.setContentHuggingPriority(.required, for: .horizontal)
        name.setContentCompressionResistancePriority(.required, for: .horizontal)
        name.easy.layout([
            Top(10), Bottom(10), Leading(16), Trailing(16)
        ])
    }
}
