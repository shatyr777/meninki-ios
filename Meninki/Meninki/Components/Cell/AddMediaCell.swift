//
//  AddMediaCell.swift
//  Meninki
//
//  Created by Shirin on 5/4/23.
//

import UIKit
import EasyPeasy

class AddMediaCell: UICollectionViewCell {
    
    static let id = "AddMediaCell"
    
    let img = UIImageView(contentMode: .scaleAspectFill,
                          cornerRadius: 10)
    
    let closeBtn = IconBtn(icon: UIImage(named: "close-circle"))

    let addBtn = AddMediaBtn()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        contentView.addSubview(img)
        img.easy.layout(Edges())
        
        contentView.addSubview(closeBtn)
        closeBtn.easy.layout([
            Trailing(), Top()
        ])
        
        contentView.addSubview(addBtn)
        addBtn.isHidden = true
        addBtn.easy.layout(Edges())
    }
    
    func setupAdd(){
        img.isHidden = true
        closeBtn.isHidden = true
        addBtn.isHidden = false
    }
    
    func setupNormal(){
        img.isHidden = false
        closeBtn.isHidden = false
        addBtn.isHidden = true
    }
}
