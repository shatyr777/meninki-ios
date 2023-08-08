//
//  ListTbCell.swift
//  Meninki
//
//  Created by Shirin on 3/29/23.
//

import UIKit
import EasyPeasy

class ListTbCell: UITableViewCell {

    static let id = "ListTbCell"
    
    var contentStack = UIStackView(axis: .horizontal,
                                   alignment: .fill,
                                   spacing: 10,
                                   edgeInsets: UIEdgeInsets(edges: 16))
    
    var title = UILabel(font: .lil_14,
                        color: .contrast,
                        alignment: .left,
                        numOfLines: 0)
    
    var desc = UILabel(font: .lil_14,
                       color: .neutralDark,
                       alignment: .left,
                       numOfLines: 0)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        contentView.addSubview(contentStack)
        contentStack.easy.layout(Edges())
        
        contentStack.addArrangedSubviews([title, desc])
    }
    
    func setupData(title: String, desc: String? = nil){
        self.title.text = title
        self.desc.text = desc
    }
}
