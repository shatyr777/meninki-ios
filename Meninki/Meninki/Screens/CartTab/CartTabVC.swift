//
//  CartTabVC.swift
//  Meninki
//
//  Created by Shirin on 3/30/23.
//

import UIKit

class CartTabVC: UIViewController {

    static var update = false
    
    var viewModel = CartTabVM()
    
    var mainView: CartTabView {
        return view as! CartTabView
    }

    override func loadView() {
        super.loadView()
        view = CartTabView()
        view.backgroundColor = .bg
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        setupBindigs()
        setupCallbacks()
        viewModel.getInCart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CartTabVC.update {
            CartTabVC.update = false
            viewModel.getInCart()
        }
    }
    
    func setupBindigs(){
        viewModel.inProgress.bind { [weak self] toShow in
            self?.mainView.loading(toShow)
        }
        
        viewModel.noContent.bind { [weak self] toShow in
            self?.mainView.noContent(toShow)
        }
        
        viewModel.noConnection.bind { [weak self] toShow in
            self?.mainView.noConnection(toShow)
        }
        
        viewModel.data.bind { [weak self] data in
            self?.setupTotalPrice()
            self?.mainView.tableView.reloadData()
        }
    }
    
    func setupCallbacks(){
        mainView.header.orderBtn.clickCallback = { [weak self] in
            if self?.viewModel.noContent.value == true {
                PopUpLauncher.showWarningMessage(text: "cart_is_empty".localized())
            } else {
                let vc = ConfirmOrderVC()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func setupTotalPrice(){
        var discountPrice = 0
        var price = 0
        
        viewModel.data.value.forEach { data in
            price += Int(data.products.reduce(0.0, {Double($1.count ?? 0)*($1.price)}))
            discountPrice += Int(data.products.reduce(0.0, {Double($1.count ?? 0)*($1.discountPrice)}))
        }
        
        mainView.header.price.text = "\(discountPrice == 0 ? price : discountPrice) TMT"
    }
}

extension CartTabVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.data.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.value[section].products.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CartTbHeader.id) as! CartTbHeader
        let shop = viewModel.data.value[section].shop
        header.setupData(imgPath: shop.imagePath, name: shop.name)
        header.clickCallback = { [weak self] in
            let vc = ShopProfileVC()
            vc.viewModel.id = shop.id
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTbCell.id, for: indexPath) as! CartTbCell
        let product = viewModel.data.value[indexPath.section].products[indexPath.row]
        cell.setupData(data: product)
        cell.inCartCountChanged = { [weak self] count in
            if count == product.count { return }
            let params = AddToCart(productId: product.id,
                                   shopId: self?.viewModel.data.value[indexPath.section].shop.id ?? "",
                                   count: count)
            self?.viewModel.changeInCartCount(params: params)
        }
        return cell
    }
}
