//
//  CartTbHeader.swift
//  Meninki
//
//  Created by Shirin on 5/3/23.
//

import UIKit
import EasyPeasy

class CartTbHeader: UITableViewHeaderFooterView {

    static let id = "CartTbHeader"
    
    var contentStack = UIStackView(axis: .horizontal,
                                   alignment: .fill,
                                   spacing: 10,
                                   edgeInsets: UIEdgeInsets(hEdges: 20, vEdges: 10))
    
    var profileImg = ProfileImg(size: 32)
    
    var name = UILabel(font: .lil_14, color: .contrast)

    var clickCallback: ( ()->() )?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        contentView.addSubview(contentStack)
        contentStack.easy.layout(Edges())
        
        contentStack.addArrangedSubviews([profileImg, name])
    }
    
    func setupData(imgPath: String?, name: String?){
        profileImg.kf.setImage(with: ApiPath.getUrl(path: imgPath ?? ""))
        self.name.text = name
    }
    
    @objc func click(){
        clickCallback?()
    }
}
