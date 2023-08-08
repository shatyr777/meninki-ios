//
//  ProfileDataStack.swift
//  Meninki
//
//  Created by Shirin on 5/2/23.
//

import UIKit
import EasyPeasy

class ProfileDataStack: UIView {

    var contentStack = UIStackView(axis: .horizontal,
                                   alignment: .center,
                                   spacing: 10,
                                   edgeInsets: UIEdgeInsets(hEdges: 10, vEdges: 14))
    
    var img = ProfileImg(size: 48)
    
    var dataStack = UIStackView(axis: .vertical,
                                alignment: .fill,
                                spacing: 4)
    
    var name = UILabel(font: .sb_16,
                       color: .black,
                       alignment: .left,
                       numOfLines: 0)
    
    var username = UILabel(font: .lil_14,
                           color: .textLc,
                           alignment: .left,
                           numOfLines: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        backgroundColor = .white
        addSubview(contentStack)
        contentStack.easy.layout(Edges())
        contentStack.setContentHuggingPriority(.required, for: .vertical)
        contentStack.addArrangedSubviews([img, dataStack])
        dataStack.addArrangedSubviews([name, username])
    }
}
