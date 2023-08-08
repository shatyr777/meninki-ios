//
//  ProductView.swift
//  Meninki
//
//  Created by Shirin on 4/4/23.
//

import UIKit
import EasyPeasy

class ProductView: BaseView {

    var header = Header(title: "product_details".localized(),
                        trailingIcon: UIImage(named: "h-more"))
    
    var footer = ProductFooter()

    var scrollView = ScrollView(spacing: 0)
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 20,
                                   edgeInsets: UIEdgeInsets(hEdges: 14, vEdges: 20))
    
    var imgCollectionView = ImageListView(size: CGSize(width: DeviceDimensions.width,
                                                       height: DeviceDimensions.width*1.2))
    
    var title = UILabel(font: .bold(size: 22),
                        color: .black)
    
    var shop = ShopDataStack()
    
    var descTitle = UILabel(font: .lil_14_b,
                            color: .contrast,
                            alignment: .left,
                            numOfLines: 0,
                            text: "desc:".localized())
    
    var desc = UILabel(font: .regular(size: 14),
                       color: .contrast)
    
    var createPostBtn = MainBtn(title: "create_post".localized())
    
    var charsView = UIStackView(axis: .vertical,
                                alignment: .fill,
                                spacing: 20)
    
    var productPosts = PostListTbCell()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(header)
        header.easy.layout([
            Top(), Leading(), Trailing()
        ])
        
        addSubview(footer)
        footer.easy.layout([
            Bottom(), Leading(), Trailing()
        ])
        
        addSubview(scrollView)
        scrollView.easy.layout([
            Top().to(header, .bottom), Leading(), Trailing(), Bottom().to(footer, .top)
        ])
    }
    
    func setupContent(){
        scrollView.contentStack.addArrangedSubviews([imgCollectionView,
                                                     contentStack])
        
        contentStack.addArrangedSubviews([title,
                                          shop,
                                          descTitle,
                                          desc,
                                          createPostBtn,
                                          charsView,
                                          productPosts.contentStack])
        
        contentStack.setCustomSpacing(10, after: descTitle)
    }
    
    func setupData(data: Product?){
        guard let data = data else { return }
        imgCollectionView.data = data.medias
        shop.setupData(data: data.shop)
        title.text = data.name
        desc.text = data.description
        footer.setupData(data: data)
        productPosts.contentStack.isHidden = data.posts?.isEmpty == true
        productPosts.type = .post
        productPosts.title.text = "posts_of_product"
        productPosts.postData = data.posts
        
        data.optionTitles?.enumerated().forEach({ (ind, title) in
            print(ind, title)
        })
    }
}
