//
//  AddPriceTbCell.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 07.05.2023.
//

import UIKit
import EasyPeasy

class AddPriceTbCell: UITableViewCell {

    static let id = "AddPriceTbCell"
    var bg = UIView()
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 10,
                                   edgeInsets: UIEdgeInsets(hEdges: 14, vEdges: 14))
    
    var optionList = UICollectionView(scrollDirection: .horizontal, minimumLineSpacing: 10, minimumInteritemSpacing: 10)
    
//    var fieldWrapper = UIStackView(axis: .vertical,
//                                   alignment: .fill,
//                                   spacing: 20,
    
    var currentPrice = TextField(title: "",
                                 value: "",
                                 placeholder: "current_price",
                                 keyboardType: .numberPad)
    
    var oldPrice = TextField(title: "",
                             value: "",
                             placeholder: "current_price",
                             keyboardType: .numberPad)
    
    var data: PersonalCharacteristics?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        optionList.register(AddPriceOptionCell.self, forCellWithReuseIdentifier: AddPriceOptionCell.id)
        optionList.delegate = self
        optionList.dataSource = self
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        contentView.addSubview(contentStack)
        contentStack.easy.layout([
            Top(10), Leading(14), Trailing(14), Bottom()
        ])
        
        optionList.easy.layout(Height(50))
        
        bg = contentStack.addBackground(color: .white,
                                        cornerRadius: 10,
                                        borderWidth: 1,
                                        borderColor: .lowContrast)
        
        contentStack.addArrangedSubviews([optionList,
                                          currentPrice,
                                          oldPrice])
    }
    
    func setupData(data: PersonalCharacteristics?){
        guard let data = data else { return }
        self.data = data
        optionList.reloadData()
        currentPrice.textField.text = "\(data.priceDiscount ?? 0)"
        oldPrice.textField.text = "\( data.price ?? 0 )"
    }
}

extension AddPriceTbCell:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.options?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPriceOptionCell.id, for: indexPath) as! AddPriceOptionCell
        cell.setupData(data: data?.options?[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let data = data?.options?[indexPath.item]
        if data?.optionType == OptionType.image.rawValue {
            return CGSize(width: 40, height: 40)
        } else {
            let width = data?.value?.width(withConstrainedHeight: 20, font: .lil_14) ?? 0
            return CGSize(width: width+24, height: 40)
        }
    }
}
