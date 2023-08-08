//
//  FeedHeader.swift
//  Meninki
//
//  Created by Shirin on 4/1/23.
//

import UIKit

class FeedHeader: UIStackView {
    
    var textStack = UIStackView(axis: .vertical,
                                alignment: .fill,
                                spacing: 6)
    
    var title = UILabel(font: .h2,
                        color: .contrast,
                        alignment: .left,
                        numOfLines: 0,
                        text: "posts".localized())
    
    var desc =  UILabel(font: .lil_14,
                        color: .neutralDark,
                        alignment: .left,
                        numOfLines: 0,
                        text: "sort".localized())
    
    var btnWrapper = UIStackView(axis: .horizontal,
                                alignment: .top,
                                spacing: 6)

    var sortBtn = IconBtn(icon: UIImage(named: "sort"))

    init(title: String){
        super.init(frame: .zero)
        
        self.title.text = title
        setupView()
        setupDesc(sortType: 0)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        axis = .horizontal
        alignment = .fill
        spacing = 10
        addMargins(insets: UIEdgeInsets(top: 26,
                                        left: 16,
                                        bottom: 16,
                                        right: 16))
        
        textStack.addArrangedSubviews([title,
                                       desc])
        
        btnWrapper.addArrangedSubview(sortBtn)
        
        addArrangedSubviews([textStack,
                             btnWrapper])
        
    }
    
    func setupDesc(sortType: SortType.RawValue){
        desc.text = SortType.allTitles[sortType]
    }
}
