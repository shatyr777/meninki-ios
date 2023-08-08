//
//  PostListTbCell.swift
//  Meninki
//
//  Created by Shirin on 4/24/23.
//

import UIKit
import EasyPeasy

enum PostListType {
    case post
    case product
}

class PostListTbCell: UITableViewCell {

    static let id = "PostListTbCell"
    
    weak var delegate: MainClicksDelegate?
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 14,
                                   edgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0))
    
    var title = UILabel(font: .h2,
                        color: .contrast,
                        alignment: .left,
                        numOfLines: 0)
    
    var collectionView = ContetnSizedPinterestCollectionView()
    
    var feedVM: FeedVM?
    
    var type = PostListType.product
    
    var postData: [Post]? = nil {
        didSet {
            if feedVM == nil {
                feedVM = FeedVM()
                feedVM?.lastPage = true
                feedVM?.data.value = postData ?? []
                setupBindings()
            }
            
            collectionView.reloadData()
        }
    }
    
    var productData: [Card]? = nil {
        didSet {
            collectionView.reloadData()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        feedVM = nil
    }
    
    func setupView(){
        let l = collectionView.collectionViewLayout as? PinterestLayout
        l?.delegate = self
        
        contentView.addSubview(contentStack)
        contentStack.easy.layout( Edges() )

        contentStack.addArrangedSubviews([title,
                                          collectionView])
    }
    
    func setupBindings(){
        feedVM?.data.bind({ [weak self] post in
            self?.postData = post
        })
    }
    
    func openMoreBS(post: Post){
        let vc = FeedMoreBS()
        vc.delegate = self
        vc.data = post
        delegate?.openBS(vc: vc)
    }
    
    func openMoreBS(product: Card){
        let vc = FeedMoreBS()
        delegate?.openBS(vc: vc)
    }
}

extension PostListTbCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postData?.count ?? productData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.id, for: indexPath) as! FeedCell
        if type == .product {
            guard let product = productData?[indexPath.row] else { return UICollectionViewCell ()}
            cell.setupData(data: product)
            cell.moreBtn.clickCallback = { [weak self] in
                self?.openMoreBS(product: product)
            }
        } else {
            guard let post = postData?[indexPath.row] else { return UICollectionViewCell ()}
            cell.setupData(data: post)
            cell.moreBtn.clickCallback = { [weak self] in
                self?.openMoreBS(post: post)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if type == .product {
            delegate?.openProduct(data: productData?[indexPath.row])
        } else {
            delegate?.openPost(feedVM: feedVM, ind: indexPath.item)
        }
    }
}

extension PostListTbCell: PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        return withWidth * 1.4
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        let text = postData?[indexPath.row].description ?? productData?[indexPath.row].name ?? ""
        let height = text.height(withConstrainedWidth: withWidth-100, font: .lil_14) + (type == .post ? 10 : 70)
        return height > 80 ? 81 : (height < 30 ? 30 : height)
    }
}

extension PostListTbCell: FeedBSDelegate {
    func like(id: String?) {
        guard let id = id else { return }
        let params = ChangeLike(id: id, isIncrease: true)
        feedVM?.changeRating(params: params)
    }

    func dislike(id: String?) {
        guard let id = id else { return }
        let params = ChangeLike(id: id, isIncrease: nil)
        feedVM?.changeRating(params: params)
    }

    func copyPath(path: String?) { }

    func goToProduct(productId: String?) {
        let vc = ProductVC()
        vc.viewModel.id = productId ?? ""
        delegate?.openVC(vc: vc)
    }
    
    func goToShopProfile(shopId: String?) {
        let vc = ShopProfileVC()
        vc.viewModel.id = shopId ?? ""
        delegate?.openVC(vc: vc)
    }

    func goToUserProfile(userId: String?) {
        let vc = UserProfileVC()
        vc.viewModel.id = userId ?? ""
        delegate?.openVC(vc: vc)
    }

    func complain(id: String?) {
        print("OPEN COMPLAIN")
    }
}
