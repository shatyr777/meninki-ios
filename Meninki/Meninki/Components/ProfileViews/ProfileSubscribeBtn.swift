//
//  ProfileSubscribeBtn.swift
//  Meninki
//
//  Created by Shirin on 5/2/23.
//

import UIKit
import EasyPeasy

class ProfileSubscribeBtn: UIView {
    
    var contentStack = UIStackView(axis: .horizontal,
                                   alignment: .fill,
                                   spacing: 10,
                                   edgeInsets: UIEdgeInsets(hEdges: 14, vEdges: 10))
    
    var title = UILabel(font: .lil_14_b,
                        color: .white,
                        alignment: .left,
                        numOfLines: 1)
    
    var icon = UIImageView(contentMode: .center, cornerRadius: .zero, backgroundColor: .clear)

    var isSubscribed = false {
        didSet {
            setupState()
        }
    }

    var subscribeClickCallback: ( ()->Void  )?
    var unsubscribeClickCallback: ( ()->Void  )?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
        setupView()
        setupState()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(contentStack)
        contentStack.easy.layout(Edges())
        icon.easy.layout(Size(20))
        
        contentStack.addArrangedSubviews([title,
                                         UIView(),
                                         icon])
    }
    
    func setupState(){
        if isSubscribed {
            backgroundColor = .lukas
            icon.image = UIImage(named: "unsubscribe")
            title.text = "unsubscribe".localized()
            
        } else {
            backgroundColor = .contrast
            icon.image = UIImage(named: "subscribe")
            title.text = "subscribe".localized()
        }
    }
    
    @objc func click(){
        if isSubscribed {
            unsubscribeClickCallback?()
        } else {
            subscribeClickCallback?()
        }
        isSubscribed = !isSubscribed
    }
}
