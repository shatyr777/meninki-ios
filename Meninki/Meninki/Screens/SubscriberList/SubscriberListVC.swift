//
//  SubscriberListVC.swift
//  Meninki
//
//  Created by Shirin on 5/3/23.
//

import UIKit

class SubscriberListVC: UIViewController {
    
    var viewModel = SubscriberListVM()
    
    var cellCount = 0
    var mainView: SubscriberListView {
        return view as! SubscriberListView
    }
    
    required init(id: String, type: SubscriberListType) {
        super.init(nibName: nil, bundle: nil)
        viewModel.type = type
        viewModel.params.id = id
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = SubscriberListView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        setupBindings()
        setupCallbacks()
        viewModel.getData(forPage: 1)
    }
    
    func setupBindings(){
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
            self?.cellCount = data.count
            self?.mainView.tableView.reloadData()
        }
    }
    
    func setupCallbacks(){
        mainView.header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension SubscriberListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubscribeTbCell.id, for: indexPath) as! SubscribeTbCell
        cell.setupData(data: viewModel.data.value[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.type.userType == .user {
            let vc = UserProfileVC()
            vc.viewModel.id = viewModel.data.value[indexPath.row].id
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = ShopProfileVC()
            vc.viewModel.id = viewModel.data.value[indexPath.row].id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cellCount <= indexPath.row+1 { return }
        viewModel.getData(forPage: viewModel.params.pageNumber+1)
    }
}
