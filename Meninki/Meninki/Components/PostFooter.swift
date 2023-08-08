//
//  PostFooter.swift
//  Meninki
//
//  Created by Shirin on 4/3/23.
//

import UIKit
import EasyPeasy

class PostFooter: UIStackView {
    
    var img = UIImageView(contentMode: .scaleAspectFill,
                          cornerRadius: 4)
    
    var desc = UILabel(font: .lil_14,
                       color: .bg,
                       alignment: .left,
                       numOfLines: 2,
                       text: "text text text")
    
    var moreBtn = IconBtn(icon: UIImage(named: "h-more")?.withRenderingMode(.alwaysTemplate), tintColor: .bg)
    
    var clickCallback: ( ()->() )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                    action: #selector(click)))
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        axis = .horizontal
        spacing = 10
        alignment = .fill
        addMargins(insets: UIEdgeInsets(edges: 14))
        
        img.easy.layout(Size(30))
        moreBtn.easy.layout(Size(30))
        
        addArrangedSubviews([img,
                             desc,
                             moreBtn])
    }
    @objc func click(){
        clickCallback?()
    }
}
