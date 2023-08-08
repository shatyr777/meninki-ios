//
//  MainVC.swift
//  Meninki
//
//  Created by Shirin on 4/24/23.
//

import UIKit

class MainVC: UIViewController {

    let viewModel = MainVM()
    
    let sheetTransitioningDelegate = SheetTransitioningDelegate()
    
    var mainView: MainView {
        return view as! MainView
    }

    var pushVc: ( (_ vc: UIViewController)->() )?
    
    override func loadView() {
        super.loadView()
        view = MainView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.tableView.refreshControl = UIRefreshControl()
        mainView.tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)

        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        setupBindings()
        setupCallbacks()
        viewModel.getData(page: 1)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.tableView.reloadData()
    }
    
    func setupBindings(){
        viewModel.data.bind { [weak self] _ in
            self?.mainView.tableView.reloadData()
        }
        
        viewModel.inProgress.bind { [weak self] toShow in
            self?.mainView.loading(toShow)
        }
        
        viewModel.noConnection.bind { [weak self] toShow in
            self?.mainView.noConnection(toShow)
        }
    }
    
    func setupCallbacks(){
        mainView.noConnection.btn.clickCallback = { [weak self] in
            self?.viewModel.getData(page: 1)
        }
        
        mainView.noContent.btn.clickCallback = { [weak self] in
            self?.viewModel.getData(page: 1)
        }
    }
    
    @objc func refresh(){
        mainView.tableView.refreshControl?.endRefreshing()
        viewModel.getData(page: 1)
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = viewModel.data.value[indexPath.row]

        switch data.type {
        case .popularPosts:
            let cell = tableView.dequeueReusableCell(withIdentifier: PostListTbCell.id, for: indexPath) as! PostListTbCell
            cell.delegate = self
            cell.title.text = "popular_post".localized()
            cell.postData = data.popularPost
            cell.type = .post
            return cell
            
        case .popularProducts:
            let cell = tableView.dequeueReusableCell(withIdentifier: PostListTbCell.id, for: indexPath) as! PostListTbCell
            cell.delegate = self
            cell.title.text = "popular_products".localized()
            cell.productData = data.popularProducts
            cell.type = .product
            return cell
            
        case .newProducts:
            let cell = tableView.dequeueReusableCell(withIdentifier: PostListTbCell.id, for: indexPath) as! PostListTbCell
            cell.delegate = self
            cell.title.text = "new_products".localized()
            cell.productData = data.newProducts
            cell.type = .product
            return cell
            
        case .shops:
            let cell = tableView.dequeueReusableCell(withIdentifier: ShopListTbCell.id, for: indexPath) as! ShopListTbCell
            cell.delegate = self
            cell.data = data.shops ?? []
            return cell

        case .banner:
            let cell = tableView.dequeueReusableCell(withIdentifier: BannerTbCell.id, for: indexPath) as! BannerTbCell
            cell.setupData(data: data.banner)
            return cell

        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == viewModel.data.value.count {
            viewModel.getData(page: viewModel.page + 1)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let banner = viewModel.data.value[indexPath.row].banner else { return }
        print(banner)
    }
}

extension MainVC: MainClicksDelegate {
    func openProduct(data: Card?) {
        let vc = ProductVC()
        vc.viewModel.id = data?.id ?? ""
        pushVc?(vc)
    }
    
    func openPost(feedVM: FeedVM?, ind: Int) {
        guard let vm = feedVM else { return }
        let vc = PostPagerVC(viewModel: vm, current: ind)
        pushVc?(vc)
    }
    
    func openBS(vc: UIViewController?) {
        guard let vc = vc else { return }
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = sheetTransitioningDelegate
        present(vc, animated: true)
    }
    
    func openVC(vc: UIViewController?) {
        guard let vc = vc else { return }
        pushVc?(vc)
    }
}


