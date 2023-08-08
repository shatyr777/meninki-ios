//
//  HomeTabView.swift
//  Meninki
//
//  Created by Shirin on 3/30/23.
//

import UIKit
import EasyPeasy

class HomeTabView: UIView {

    var container = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(container)
        container.easy.layout([
            Top(4).to(safeAreaLayoutGuide, .top),
            Bottom().to(safeAreaLayoutGuide, .bottom),
            Leading(), Trailing()
        ])
    }
    
    func addPagerView(_ view: UIView){
        container.addSubview(view)
        view.easy.layout([
            Top(), Bottom(), Leading(8), Trailing(8)
        ])
    }
}
