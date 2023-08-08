//
//  CategoryTbCell.swift
//  Meninki
//
//  Created by Shirin on 4/1/23.
//

import UIKit
import EasyPeasy

class CategoryTbCell: UITableViewCell {

    static let id = "CategoryTbCell"
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 0)

    var nameWrapper = UIStackView(axis: .horizontal,
                                  alignment: .fill,
                                  spacing: 0,
                                  edgeInsets: UIEdgeInsets(hEdges: 30, vEdges: 12))
    
    var name = UILabel(font: .lil_14,
                       color: .contrast,
                       alignment: .left,
                       numOfLines: 0,
                       text: "category name goes here")
    
    var advertWrapper = UIStackView(axis: .horizontal,
                                    alignment: .fill,
                                    spacing: 0,
                                    edgeInsets: UIEdgeInsets(hEdges: 30, vEdges: 12))
    
    var advert = UILabel(font: .lil_14,
                         color: .lukas,
                         alignment: .left,
                         numOfLines: 0,
                         text: "* addvert here")

    var adverClickCallback: ( ()->() )?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        
        advertWrapper.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(advertClick)))
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        contentView.addSubview(contentStack)
        contentStack.easy.layout(Edges())

        nameWrapper.addArrangedSubview(name)
        advertWrapper.addArrangedSubview(advert)
    }
    
    func seperator() -> UIView {
        let v = UIView()
        v.backgroundColor = .onBgLc
        v.easy.layout(Height(1))
        return v
    }
    
    func setupData(data: Category?){
        guard let data = data else { return }
        name.text = data.getTitle()
        
        if data.advertisement != nil {
            contentStack.addArrangedSubviews([seperator(),
                                              nameWrapper,
                                              seperator(),
                                              advertWrapper])
            
            advert.text = "• " + data.advertisement!.name
        } else {
            contentStack.removeSubviews()
            contentStack.addArrangedSubviews([seperator(),
                                              nameWrapper])
        }
    }
    
    @objc func advertClick(){
        adverClickCallback?()
    }
}
