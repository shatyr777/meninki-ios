//
//  CategoryListVC.swift
//  Meninki
//
//  Created by Shirin on 4/1/23.
//

import UIKit

class CategoryListVC: UIViewController {

    var data: [Category] = []
    
    var pushVc: ( (_ vc: UIViewController)->() )?

    var mainView: CategoryListView {
        return view as! CategoryListView
    }

    required init(categories: [Category]) {
        super.init(nibName: nil, bundle: nil)
        data = categories
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = CategoryListView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
}

extension CategoryListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTbCell.id, for: indexPath) as! CategoryTbCell
        cell.setupData(data: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CategoryProductListVC()
        vc.viewModel.category = data[indexPath.row]
        pushVc?(vc)
    }
}
