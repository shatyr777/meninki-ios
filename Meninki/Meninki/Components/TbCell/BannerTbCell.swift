//
//  BannerTbCell.swift
//  Meninki
//
//  Created by Shirin on 4/30/23.
//

import UIKit
import EasyPeasy

class BannerTbCell: UITableViewCell {
    
    static let id = "BannerTbCell"
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 4,
                                   edgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0))
    
    var img = UIImageView(contentMode: .scaleAspectFill,
                          cornerRadius: 10)
    
    var title = UILabel(font: .lil_14_b,
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
        
        img.easy.layout(Height(DeviceDimensions.width/2))
        
        contentStack.addArrangedSubviews([img,
                                         title,
                                         desc])
        
    }
    
    func setupData(data: Banner?){
        guard let data = data else { return }
        img.kf.setImage(with: ApiPath.getUrl(path: data.bannerImage?.directoryCompressed ?? ""))
        title.text = data.title
        desc.text = data.description
    }
}
