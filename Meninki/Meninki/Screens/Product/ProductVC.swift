//
//  ProductVC.swift
//  Meninki
//
//  Created by Shirin on 4/4/23.
//

import UIKit

class ProductVC: UIViewController {

    let viewModel = ProductVM()
    
    let sheetTransitioningDelegate = SheetTransitioningDelegate()

    var selectedPersonalChar: PersonalCharacteristics?
    
    var mainView: ProductView {
        return view as! ProductView
    }

    override func loadView() {
        super.loadView()
        view = ProductView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.productPosts.delegate = self


        setupCallbacks()
        setupBindings()
        viewModel.getProduct()
    }
    
    func setupBindings(){
        viewModel.product.bind { [weak self] product in
            self?.mainView.setupData(data: product)
        }
        
        viewModel.inProgress.bind { [weak self] toShow in
            self?.mainView.loading(toShow)
        }
        
        viewModel.noConnection.bind { [weak self] toShow in
            self?.mainView.noConnection(toShow)
        }
    }
    
    func setupCallbacks(){
        mainView.header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        mainView.header.trailingBtn.clickCallback = { [weak self] in
            print("trailing click")
        }
        
        mainView.shop.clickCallback = { [weak self] in
            let vc = ShopProfileVC()
            vc.viewModel.id = self?.viewModel.product.value?.shop?.id ?? ""
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        mainView.createPostBtn.clickCallback = { [weak self] in
            let vc = AddPostVC()
            vc.viewModel.productId = self?.viewModel.product.value?.id ?? ""
            vc.mainView.productData.setupData(data: self?.viewModel.product.value)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        mainView.footer.likeBtn.clickCallback = { [weak self] in
            self?.changeRating()
        }
        
        mainView.footer.cartBtn.clickCallback = { [weak self] in
            self?.viewModel.addToCart()
        }
    }
      
            
    func changeRating(){
        let isLiked = viewModel.product.value?.rating?.userRating?.keys.contains(where: {$0 == AccUserDefaults.id}) ?? false
        mainView.footer.likeBtn.setImage(UIImage(named: !isLiked ? "heart-filled-24" : "heart-24"), for: .normal)

        let id = viewModel.product.value?.id ?? ""
        if isLiked == false {
            viewModel.changeRating(params: ChangeLike(id: id, isIncrease: true))
        } else {
            viewModel.changeRating(params: ChangeLike(id: id, isIncrease: nil))
        }
    }
}

extension ProductVC: MainClicksDelegate {
    func openProduct(data: Card?) { }
    
    func openPost(feedVM: FeedVM?, ind: Int) {
        guard let vm = feedVM else { return }
        let vc = PostPagerVC(viewModel: vm, current: ind)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func openBS(vc: UIViewController?) {
        guard let vc = vc else { return }
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = sheetTransitioningDelegate
        present(vc, animated: true)
    }
    
    func openVC(vc: UIViewController?) {
        guard let vc = vc else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}
