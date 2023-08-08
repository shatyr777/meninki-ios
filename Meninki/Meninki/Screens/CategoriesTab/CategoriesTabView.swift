//
//  CategoriesTabView.swift
//  Meninki
//
//  Created by Shirin on 4/1/23.
//

import UIKit
import EasyPeasy

class CategoriesTabView: BaseView {
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 0)
    
    var searchStack = UIStackView(axis: .horizontal,
                                  alignment: .fill,
                                  spacing: 6)
    var search = SearchBar()

    var filterBtn = IconBtn(icon: UIImage(named: "filter"))
    
    var btns = CategoryBtnView()
    
    var container = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(searchStack)
        searchStack.easy.layout([
            Top(16).to(safeAreaLayoutGuide, .top),
            Leading(16),
            Trailing(16)
        ])

        addSubview(contentStack)
        contentStack.easy.layout([
            Top(16).to(searchStack, .bottom),
            Bottom().to(safeAreaLayoutGuide, .bottom),
            Leading(), Trailing()
        ])
        
        searchStack.addArrangedSubviews([search, filterBtn])
        
        contentStack.addArrangedSubviews([btns,
                                          container])
    }
    
    func addViewToContainer(_ view: UIView){
        container.addSubview(view)
        view.easy.layout(Edges())
    }
}
