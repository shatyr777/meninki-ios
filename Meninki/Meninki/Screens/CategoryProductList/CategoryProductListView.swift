//
//  CategoryProductListView.swift
//  Meninki
//
//  Created by Shirin on 4/3/23.
//

import UIKit
import EasyPeasy

class CategoryProductListView: UIView {
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 0)

    var header = Header(title: "")
    
    var search = SearchBar()

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
        addSubview(contentStack)
        contentStack.easy.layout([
            Top(),
            Bottom().to(safeAreaLayoutGuide, .bottom),
            Leading(), Trailing()
        ])
        
        contentStack.addArrangedSubviews([header,
                                          btns,
                                          container])
    }
    
    func addViewToContainer(_ view: UIView){
        container.addSubview(view)
        view.easy.layout([
            Top(), Leading(4), Trailing(4), Bottom()
        ])
    }
}
