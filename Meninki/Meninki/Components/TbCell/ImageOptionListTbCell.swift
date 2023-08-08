//
//  ImageOptionListTbCell.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 06.05.2023.
//

import UIKit
import EasyPeasy
import TLPhotoPicker

class ImageOptionListTbCell: UITableViewCell {

    static let id = "ImageOptionListTbCell"
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 10,
                                   edgeInsets: UIEdgeInsets(vEdges: 10))
    
    var headerStack = UIStackView(axis: .horizontal,
                                  alignment: .fill,
                                  spacing: 0)
    
    var title = UILabel(font: .sb_16,
                        color: .contrast)
    
    var editBtn = IconBtn(icon: UIImage(named: "edit"))
                          
    var deleteBtn = IconBtn(icon: UIImage(named: "delete"))
    
    var collectionView = UICollectionView(scrollDirection: .horizontal,
                                          itemSize: CGSize(width: 100, height: 100),
                                          minimumLineSpacing: 10,
                                          minimumInteritemSpacing: 10)

    var withAdd = false
    
    var data: [Option] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var images: [UploadImage] = []

    var deleteClickCallback: ( (_ ind: Int)->() )?
    var addClickCallback: ( ()->() )?
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        collectionView.register(AddMediaCell.self, forCellWithReuseIdentifier: AddMediaCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        
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
        collectionView.easy.layout(Height(110))
        
        contentStack.addArrangedSubviews([headerStack, collectionView])
        headerStack.addArrangedSubviews([title, UIView(), editBtn, deleteBtn])
    }
    
    func hideEditBtns(){
        editBtn.isHidden = !withAdd
        deleteBtn.isHidden = !withAdd
    }
}

extension ImageOptionListTbCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count + (withAdd ? 1 : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddMediaCell.id, for: indexPath) as! AddMediaCell
        
        if data.count != indexPath.item {
            let data = data[indexPath.item]
            cell.setupNormal()
            if data.imagePath != nil {
                cell.img.kf.setImage(with: ApiPath.getUrl(path: data.imagePath ?? ""))
            } else {
                let imageData = images.first(where: {$0.objectId == data.id})?.data
                cell.img.image = UIImage(data: imageData ?? Data())
            }

            cell.closeBtn.clickCallback = { [weak self] in
                self?.deleteClickCallback?(indexPath.item)
            }
            
        } else {
            cell.setupAdd()
            cell.addBtn.clickCallback = { [weak self] in
                self?.addClickCallback?()
            }
        }
        return cell
    }
}
