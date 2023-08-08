//
//  SubscribeBtn.swift
//  Meninki
//
//  Created by Shirin on 4/4/23.
//

import UIKit
import EasyPeasy

class SubscribeBtn: UIView {
    
    var title = UILabel(font: .lil_12,
                        color: .bg,
                        alignment: .center,
                        numOfLines: 1,
                        text: "subscribe".localized())
    
    var isSubscribed: Bool = false {
        didSet {
            if isSubscribed {
                backgroundColor = .neutralDark.withAlphaComponent(0.5)
                title.text = "unsubscribe".localized()
            } else {
                backgroundColor = .lukas
                title.text = "subscribe".localized()
            }
        }
    }
    
    var subscribeClickCallback: ( ()->() )?
    var unsubscribeClickCallback: ( ()->() )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        title.setContentHuggingPriority(.required, for: .horizontal)
        layer.cornerRadius = 4

        addSubview(title)
        title.easy.layout([
            Edges(4)
        ])
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
