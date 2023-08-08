//
//  BottomSheetView.swift
//  Meninki
//
//  Created by Shirin on 4/22/23.
//

import UIKit
import EasyPeasy

class BottomSheetView: UIView {

    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 8,
                                   edgeInsets: UIEdgeInsets(hEdges: 16, vEdges: 20),
                                   backgroundColor: .lowContrast,
                                   cornerRadius: 10)
    
    var title = UILabel(font: .sb_16,
                        color: .black,
                        alignment: .left,
                        numOfLines: 0,
                        text: "title")
    
    var desc = UILabel(font: .lil_14,
                        color: .contrast,
                        alignment: .left,
                        numOfLines: 0,
                        text: "desc")

    var btnStack = UIStackView(axis: .vertical,
                               alignment: .fill,
                               spacing: 8)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(contentStack)
        contentStack.easy.layout(Edges())
        
        contentStack.addArrangedSubviews([title,
                                          desc,
                                          btnStack])
    }
}
