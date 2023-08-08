//
//  SearchTbCell.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 17.05.2023.
//

import UIKit
import EasyPeasy

class SearchTbCell: UITableViewCell {

    static let id = "search-tb-cell"
    
    var contnetStack = UIStackView(axis: .horizontal,
                                   alignment: .center,
                                   spacing: 14,
                                   edgeInsets: UIEdgeInsets(hEdges: 16, vEdges: 10))

    var icon: UIImageView = {
        let v = UIImageView(image: UIImage(named: "search"))
        v.easy.layout(Size(18))
        return v
    }()

    var title = UILabel(font: .lil_14, color: .black, alignment: .left, numOfLines: 0)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        contentView.addSubview(contnetStack)
        contnetStack.easy.layout(Edges())
        
        contnetStack.addArrangedSubviews([icon, title])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
