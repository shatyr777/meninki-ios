//
//  AddressTbCell.swift
//  Meninki
//
//  Created by Shirin on 5/3/23.
//

import UIKit
import EasyPeasy

class AddressTbCell: UITableViewCell {

    static let id = "AddressTbCell"
    
    var contentStack: UIView = {
        let v = UIView()
        v.backgroundColor = .lowContrast
        v.layer.cornerRadius = 4
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.clear.cgColor
        return v
    }()
    
    var title = UILabel(font: .lil_14_b,
                        color: .contrast)
    
    
    override var isSelected: Bool {
        didSet {
            contentStack.layer.borderColor = (isSelected ? UIColor.contrast : UIColor.clear).cgColor
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        contentView.addSubview(contentStack)
        contentStack.easy.layout([
            Top(10), Leading(20), Trailing(20), Bottom()
        ])
        
        contentStack.addSubview(title)
        title.easy.layout([
            Top(14), Leading(14), Trailing(14), Bottom(14)
        ])
    }
}
