//
//  ProductTextCell.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 07.05.2023.
//

import UIKit
import EasyPeasy

class ProductTextCell: UICollectionViewCell {
    
    static let id = "ProductTextCell"
    
//    override var isSelected: Bool {
//        didSet {
//            if isSelected {
//                
//            }
//        }
//    }
    
    var bg = UIView()
    
    var contentStack = UIStackView(axis: .horizontal,
                                   alignment: .fill,
                                   spacing: 0,
                                   edgeInsets: UIEdgeInsets(hEdges: 10))
    
    var title = UILabel(font: .lil_14,
                        color: .contrast,
                        alignment: .justified,
                        numOfLines: 1)
    
    var closeBtn = IconBtn(icon: UIImage(named: "delete"))
    
    var addBtn = AddValueBtn()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        contentView.addSubview(contentStack)
        contentStack.easy.layout(Edges())
        
        bg = contentStack.addBackground(color: .lowContrast, cornerRadius: 10)
    }
    
    func setupNormal(withClose: Bool = true){
        contentStack.addArrangedSubview(title)

        addBtn.removeFromSuperview()
        if !withClose {
            closeBtn.removeFromSuperview()
        } else {
            contentStack.addArrangedSubview(closeBtn)
        }
        
    }
    
    func setupAdd(){
        title.removeFromSuperview()
        closeBtn.removeFromSuperview()
        contentStack.addArrangedSubview(addBtn)
    }
}
