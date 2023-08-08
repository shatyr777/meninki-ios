//
//  ValueOptionListTbCell.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 06.05.2023.
//

import UIKit
import EasyPeasy

class ValueOptionListTbCell: UITableViewCell {

    static let id = "ValueOptionListTbCell"
    
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
                                          itemSize: UICollectionViewFlowLayout.automaticSize,
                                          minimumLineSpacing: 10,
                                          minimumInteritemSpacing: 10)

    var withAdd = false

    var data: [Option] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    var deleteClickCallback: ( (_ ind: Int)->() )?
    var addClickCallback: ( ()->() )?
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        collectionView.register(ProductTextCell.self, forCellWithReuseIdentifier: ProductTextCell.id)
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
        collectionView.easy.layout(Height(50))
        
        contentStack.addArrangedSubviews([headerStack, collectionView])
        headerStack.addArrangedSubviews([title, UIView(), editBtn, deleteBtn])
    }
    
    func hideEditBtns(){
        editBtn.isHidden = !withAdd
        deleteBtn.isHidden = !withAdd
    }
}

extension ValueOptionListTbCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count + (withAdd ? 1 : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductTextCell.id, for: indexPath) as! ProductTextCell
        
        if data.count != indexPath.item {
            cell.setupNormal()
            cell.title.text = data[indexPath.item].value

            cell.closeBtn.clickCallback = { [weak self] in
                self?.deleteClickCallback?(indexPath.item)
                collectionView.reloadData()
            }
            
        } else {
            cell.setupAdd()
            cell.addBtn.clickCallback = { [weak self] in
                self?.addClickCallback?()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if data.count != indexPath.item {
            let width = data[indexPath.item].value?.width(withConstrainedHeight: 20, font: .lil_14) ?? 100
            return CGSize(width: width+60, height: 40)
        }
        
        let width = "add".localized().width(withConstrainedHeight: 20, font: .lil_14) 
        return CGSize(width: width+60, height: 40)
    }
}
