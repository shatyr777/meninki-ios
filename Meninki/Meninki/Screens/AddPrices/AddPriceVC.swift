//
//  AddPriceVC.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 06.05.2023.
//

import UIKit

class AddPriceVC: UIViewController {

    weak var parentVC: AddProductVC?
    
    var viewModel = AddPriceVM()
        
    var mainView: AddPriceView {
        return view as! AddPriceView
    }
    
    override func loadView() {
        super.loadView()
        view = AddPriceView()
        view.backgroundColor = .bg
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.tableView.dataSource = self

        setupBindings()
        setupCallbacks()
    }
    
    func setupBindings(){
        viewModel.inProgress.bind { [weak self] toShow in
            self?.mainView.loading(toShow)
        }
        
        viewModel.personalCharsAdded.bind { [weak self] success in
            if success == false { return }
            self?.parentVC?.personalChars = self?.viewModel.personalChars ?? []
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func setupCallbacks(){
        mainView.header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        mainView.doneBtn.clickCallback = { [weak self] in
            self?.view.endEditing(true)
            self?.viewModel.updatePersonalChars()
        }
    }
}

extension AddPriceVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.personalChars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddPriceTbCell.id, for: indexPath) as! AddPriceTbCell
        cell.setupData(data: viewModel.personalChars[indexPath.row])
        cell.currentPrice.didEndEditing = { [weak self] text in
            self?.viewModel.personalChars[indexPath.row].priceDiscount = Double(text)
        }
        
        cell.oldPrice.didEndEditing = { [weak self] text in
            self?.viewModel.personalChars[indexPath.row].price = Double(text)
        }
        return cell
    }
}
