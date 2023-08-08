//
//  SubscribeTbCell.swift
//  Meninki
//
//  Created by Shirin on 5/3/23.
//

import UIKit
import EasyPeasy

class SubscribeTbCell: UITableViewCell {
    
    static let id = "SubscribeTbCell"
    
    var contentStack = UIStackView(axis: .horizontal,
                                   alignment: .fill,
                                   spacing: 10,
                                   edgeInsets: UIEdgeInsets(edges: 10),
                                   backgroundColor: .lowContrast,
                                   cornerRadius: 10)
    
    var profileImg = ProfileImg(size: 38)
    
    var titleStack = UIStackView(axis: .vertical,
                                 alignment: .fill,
                                 spacing: 2)
    
    var name = UILabel(font: .lil_14,
                       color: .contrast)
    
    var username = UILabel(font: .lil_12,
                           color: .contrast)
    
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
        contentStack.easy.layout([
            Top(4), Leading(14), Trailing(14), Bottom()
        ])
        
        contentStack.addArrangedSubviews([profileImg, titleStack])
        titleStack.addArrangedSubviews([name, username])
    }
    
    func setupData(data: User?){
        guard let data = data else { return }
        profileImg.kf.setImage(with: ApiPath.getUrl(path: data.imgPath ?? ""))
        name.text = data.name.trimmingCharacters(in: .whitespacesAndNewlines)
        username.text = data.userName ?? data.phoneNumber ?? data.email
    }
}
