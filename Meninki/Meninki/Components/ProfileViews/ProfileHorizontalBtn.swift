//
//  ProfileHorizontalBtn.swift
//  Meninki
//
//  Created by Shirin on 5/3/23.
//

import UIKit
import EasyPeasy

class ProfileHorizontalBtn: UIView {

    var contentStack = UIStackView(axis: .horizontal,
                                   alignment: .fill,
                                   spacing: 10,
                                   edgeInsets: UIEdgeInsets(hEdges: 14, vEdges: 14))
    
    var title = UILabel(font: .lil_14,
                        color: .contrast,
                        alignment: .left,
                        numOfLines: 1)
    
    var icon = UIImageView(contentMode: .center, cornerRadius: .zero, backgroundColor: .clear)

    var clickCallback: ( ()->() )?
    
    init(title: String, icon: String){
        super.init(frame: .zero)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
        self.title.text = title
        self.icon.image = UIImage(named: icon)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        backgroundColor = .white
        addSubview(contentStack)
        contentStack.easy.layout(Edges())
        icon.easy.layout(Size(20))
        
        contentStack.addArrangedSubviews([title,
                                         UIView(),
                                         icon])
    }
    
    @objc func click(){
        clickCallback?()
    }
}
