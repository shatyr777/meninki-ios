//
//  FilterView.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 19.05.2023.
//

import UIKit
import EasyPeasy

class FilterView: UIView {

    var scrollView = ScrollView(spacing: 20,
                                edgeInsets: UIEdgeInsets(hEdges: 16, vEdges: 10))
    
    var header = Header(title: "filter".localized())
    
    var sort = TextField(title: "sort_type".localized(),
                         value: SortType.allTitles.first ?? "",
                         placeholder: "",
                         trailingIcon: UIImage(named: "forward")?.withRenderingMode(.alwaysTemplate))
    
    var category = TextField(title: "category".localized(),
                             value: "",
                             placeholder: "category".localized(),
                             trailingIcon: UIImage(named: "forward")?.withRenderingMode(.alwaysTemplate))

    var doneBtn = MainBtn(title: "done".localized())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView(){
        addSubview(header)
        header.easy.layout([
            Top(), Leading(), Trailing()
        ])
        
        addSubview(doneBtn)
        doneBtn.easy.layout([
            Bottom(20).to(safeAreaLayoutGuide, .bottom), Leading(16), Trailing(16)
        ])
        
        addSubview(scrollView)
        scrollView.easy.layout([
            Top().to(header, .bottom), Leading(), Trailing(), Bottom().to(doneBtn, .top)
        ])

        category.makeTextView()
        sort.textField.isUserInteractionEnabled = false
        category.textView.isUserInteractionEnabled = false
        scrollView.contentStack.addArrangedSubviews([sort, category])
    }
}
