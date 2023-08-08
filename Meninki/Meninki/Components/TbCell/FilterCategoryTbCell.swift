//
//  FilterCategoryTbCell.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 06.05.2023.
//

import UIKit
import EasyPeasy

class FilterCategoryTbCell: UITableViewCell {

    static let id = "FilterCategoryTbCell"
    
    var contentStack = UIStackView(axis: .horizontal,
                                   alignment: .fill,
                                   spacing: 10,
                                   edgeInsets: UIEdgeInsets(hEdges: 14, vEdges: 14))
    
    var name = UILabel(font: .lil_14_b,
                       color: .contrast)
    
    var icon = UIImageView(contentMode: .scaleAspectFit,
                           cornerRadius: .zero,
                           image: UIImage(named: "forward")?.withRenderingMode(.alwaysTemplate),
                           backgroundColor: .clear,
                           tintColor: .contrast)
    
    var checkbox = Checkbox(frame: .zero)
    
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
        icon.easy.layout(Size(16))
        checkbox.easy.layout(Size(24))
        contentStack.addArrangedSubviews([name])
    }
    
    func setupData(data: Category?) {
        guard let data = data else { return }
        name.text = data.getTitle()
        if (data.subCategories ?? []).isEmpty {
            icon.removeFromSuperview()
            contentStack.addArrangedSubview(checkbox)
        } else {
            checkbox.removeFromSuperview()
            contentStack.addArrangedSubview(icon)
        }
    }
}
