//
//  AddPriceOptionCell.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 07.05.2023.
//

import UIKit
import EasyPeasy

class AddPriceOptionCell: UICollectionViewCell {
    
    static let id = "AddPriceOptionCell"
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 0)
    
    var img = UIImageView(contentMode: .scaleAspectFill, cornerRadius: 8)
    
    var titleWrapper = UIStackView(axis: .horizontal,
                                   alignment: .fill,
                                   spacing: 0,
                                   edgeInsets: UIEdgeInsets(hEdges: 12, vEdges: 10),
                                   backgroundColor: .lowContrast,
                                   cornerRadius: 8)
    
    var title = UILabel(font: .lil_14,
                        color: .contrast,
                        alignment: .center,
                        numOfLines: 1)
    
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
        titleWrapper.addArrangedSubview(title)
    }
    
    func setupData(data: Option?){
        guard let data = data else { return }
        if data.optionType == OptionType.image.rawValue {
            contentStack.addArrangedSubview(img)
            titleWrapper.removeFromSuperview()
            img.kf.setImage(with: ApiPath.getUrl(path: data.imagePath ?? ""))
        } else {
            contentStack.addArrangedSubview(titleWrapper)
            img.removeFromSuperview()
            title.text = data.value
        }
    }
}
