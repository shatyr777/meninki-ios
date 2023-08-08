//
//  AddPostView.swift
//  Meninki
//
//  Created by Shirin on 5/1/23.
//

import UIKit
import EasyPeasy

class AddPostView: BaseView {
    
    var header = Header(title: "add_post".localized())
    
    var scrollView = ScrollView(spacing: 20,
                                edgeInsets: UIEdgeInsets(edges: 14))
    
    var productData = ProductInfoView()
    
    var textView = TextField(title: "desc_optional".localized(),
                             value: "",
                             placeholder: "desc_optional".localized())
    
    var mediaCollectionView = MediaListView(columns: 2)
    
    var doneBtn = MainBtn(title: "done".localized())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textView.makeTextView()
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
        
        addSubview(doneBtn)
        doneBtn.easy.layout([
            Bottom(20).to(safeAreaLayoutGuide, .bottom), Leading(20), Trailing(20)
        ])
        
        addSubview(scrollView)
        scrollView.easy.layout([
            Top().to(header, .bottom), Bottom().to(doneBtn, .top),
            Leading(), Trailing()
        ])
        
        scrollView.contentStack.addArrangedSubviews([productData,
                                                     textView,
                                                     mediaCollectionView])
    }
    
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        guard let keyboardRectangle = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardRectangle.size.height
        
        DispatchQueue.main.asyncAfter(deadline: .now() ) {
            UIView.animate(withDuration: 0.2) { [weak self] in
                guard let self = self else { return }
                self.doneBtn.easy.layout( Bottom(keyboardHeight + 20 ))
                self.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        UIView.animate(withDuration: 0.0001) { [weak self] in
            guard let self = self else { return }
            self.doneBtn.easy.layout( Bottom().to(self.safeAreaLayoutGuide, .bottom))
            self.layoutIfNeeded()
        }
    }
}
