//
//  AddProductView.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 06.05.2023.
//

import UIKit
import EasyPeasy

class AddProductView: BaseView {

    var header = Header(title: "add_product".localized())
    
    var scrollView = ScrollView(spacing: 20,
                                edgeInsets: UIEdgeInsets(edges: 14),
                                keyboardDismissMode: .interactive)
    
    var name = TextField(title: "name".localized(),
                         value: "",
                         placeholder: "name".localized())
        
    var category = TextField(title: "category".localized(),
                             value: "",
                             placeholder: "category".localized(),
                             trailingIcon: UIImage(named: "forward")?.withRenderingMode(.alwaysTemplate))
    
    var shop = TextField(title: "shop".localized(),
                         value: "",
                         placeholder: "shop".localized(),
                         trailingIcon: UIImage(named: "forward")?.withRenderingMode(.alwaysTemplate))
    
    var desc = TextField(title: "desc_optional".localized(),
                         value: "",
                         placeholder: "desc_optional".localized())
    
    var priceSectionTitle = UILabel(font: .sb_16,
                                    color: .contrast,
                                    alignment: .center,
                                    numOfLines: 0,
                                    text: "pricing".localized())
    
    var price = TextField(title: "current_price".localized(),
                          value: "",
                          placeholder: "current_price".localized(),
                          keyboardType: .numberPad)
    
    var oldPrice = TextField(title: "old_price".localized(),
                             value: "",
                             placeholder: "old_price".localized(),
                             keyboardType: .numberPad)
    
    var mediaCollectionView = MediaListView(columns: 3)
    
    var charsSectionTitle = UILabel(font: .sb_16,
                                    color: .contrast,
                                    alignment: .center,
                                    numOfLines: 0,
                                    text: "product_chars_title".localized())
    
    var charsSectionDesc = UILabel(font: .lil_14,
                                   color: .neutralDark,
                                   alignment: .left,
                                   numOfLines: 0,
                                   text: "product_chars_desc".localized())
    
    var optionsBtn = AddProductPriceStack(btnTitle: "see_options".localized())
    
    var pricesBtn = AddProductPriceStack(btnTitle: "edit_prices".localized())
    
    var addCharBtn = TextIconBtn(title: "add_chars".localized(), icon: UIImage(named: "forward")?.withRenderingMode(.alwaysTemplate))
    
    var doneBtn = MainBtn(title: "done".localized())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        desc.makeTextView()
        category.makeTextView()
        category.textView.isUserInteractionEnabled = false
        shop.textField.isUserInteractionEnabled = false
        mediaCollectionView.title.textAlignment = .center
        addCharBtn.makeContrast()
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(header)
        header.easy.layout([
            Top(), Leading(), Trailing()
        ])
        
        addSubview(scrollView)
        scrollView.easy.layout([
            Top().to(header, .bottom), Bottom().to(safeAreaLayoutGuide, .bottom),
            Leading(), Trailing()
        ])
        
        scrollView.contentStack.addArrangedSubviews([name,
                                                     category,
                                                     shop,
                                                     desc,
                                                     priceSectionTitle,
                                                     price,
                                                     oldPrice,
                                                     mediaCollectionView,
                                                     charsSectionTitle,
                                                     charsSectionDesc,
                                                     addCharBtn,
                                                     optionsBtn,
                                                     pricesBtn,
                                                     doneBtn])
    }
    
    func setupPersonalCharCount(_ count: Int){
        optionsBtn.setupCount(count: count)
        pricesBtn.setupCount(count: count)

        if count != 0 {
            priceSectionTitle.isHidden = true
            price.isHidden = true
            oldPrice.isHidden = true
            addCharBtn.isHidden = true
            optionsBtn.isHidden = false
            pricesBtn.isHidden = false
        } else {
            priceSectionTitle.isHidden = false
            price.isHidden = false
            oldPrice.isHidden = false
            addCharBtn.isHidden = false
            optionsBtn.isHidden = true
            pricesBtn.isHidden = true
        }
    }
    
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification){
        guard let keyboardRectangle = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardRectangle.size.height
        
        DispatchQueue.main.asyncAfter(deadline: .now() ) {
            UIView.animate(withDuration: 0.2) { [weak self] in
                guard let self = self else { return }
                self.scrollView.contentInset.bottom = keyboardHeight + 20
                self.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        UIView.animate(withDuration: 0.0001) { [weak self] in
            guard let self = self else { return }
            self.scrollView.contentInset.bottom = 0
            self.layoutIfNeeded()
        }
    }
}
