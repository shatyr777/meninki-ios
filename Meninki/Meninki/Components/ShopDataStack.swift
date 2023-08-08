//
//  ShopDataStack.swift
//  Meninki
//
//  Created by Shirin on 4/4/23.
//

import UIKit
import EasyPeasy

class ShopDataStack: UIStackView {
    
    var bg = UIView()
    
    var img = UIImageView(contentMode: .scaleAspectFill,
                          cornerRadius: 18)
    
    var textStack = UIStackView(axis: .vertical,
                                alignment: .fill,
                                spacing: 2)
    
    var name = UILabel(font: .lil_14,
                       color: .contrast,
                       alignment: .left,
                       numOfLines: 1)
    
    var desc = UILabel(font: .lil_12,
                       color: .neutralDark,
                       alignment: .left,
                       numOfLines: 1,
                       text: "go_to_shop_profile".localized())
    
    var icon = UIImageView(contentMode: .scaleToFill,
                           cornerRadius: 0,
                           image: UIImage(named: "forward"),
                           backgroundColor: .clear)
    
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
        alignment = .center
        spacing = 10
        addMargins(insets: UIEdgeInsets(edges: 10))
        bg = addBackground(color: .lowContrast,
                           cornerRadius: 10)
        
        addArrangedSubviews([img,
                             textStack,
                             icon])
        
        textStack.addArrangedSubviews([name,
                                       desc])
        
        img.easy.layout(Size(38))
        icon.easy.layout(Size(24))
    }
    
    func setupData(data: User?){
        guard let data = data else { return }
        img.kf.setImage(with: ApiPath.getUrl(path: data.imgPath ?? ""))
        name.text = data.name
    }
    
    @objc func click(){
        clickCallback?()
    }
}
