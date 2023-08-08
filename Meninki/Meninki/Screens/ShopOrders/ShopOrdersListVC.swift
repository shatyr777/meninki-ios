//
//  ShopOrdersListVC.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 08.05.2023.
//

import UIKit

class ShopOrdersListVC: UIViewController {

    var viewModel = ShopOrdersListVM()

    var pushVC: ((UIViewController)->())?
    var mainView: ShopOrdersListView {
        return view as! ShopOrdersListView
    }

    override func loadView() {
        super.loadView()
        view = ShopOrdersListView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        setupBindings()
        viewModel.getData()
    }
    
    func setupBindings(){
        viewModel.data.bind { [weak self] data in
            self?.mainView.tableView.reloadData()
        }
        
        viewModel.inProgress.bind { [weak self] toShow in
            self?.mainView.loading(toShow)
        }
        
        viewModel.noContent.bind { [weak self] toShow in
            self?.mainView.noContent(toShow)
        }

        viewModel.noConnection.bind { [weak self] toShow in
            self?.mainView.noConnection(toShow)
        }
    }
}

extension ShopOrdersListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderTbCell.id, for: indexPath) as! OrderTbCell
        let data = viewModel.data.value[indexPath.row]
        cell.setupData(data: data)
        cell.deliverBtn.clickCallback = { [weak self] in
            self?.viewModel.changeStatus(params: ChangeOrder(id: data.id))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProductVC()
        vc.viewModel.id = viewModel.data.value[indexPath.row].products.first?.product.id ?? ""
        pushVC?(vc)
    }
}
