//
//  SelectAddresVC.swift
//  Meninki
//
//  Created by Shirin on 5/3/23.
//

import UIKit

class SelectAddresVC: UIViewController {

    var addresses = AccUserDefaults.addresses
    var isClosed = true

    var selectedAddress: ( (_ address: String)->() )?
    
    var mainView: SelectAddressView {
        return view as! SelectAddressView
    }

    override func loadView() {
        super.loadView()
        view = SelectAddressView()
        view.backgroundColor = .bg
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        mainView.addObserver()
        setupCallbacks()
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    func setupAdditions(){
        addresses = AccUserDefaults.addresses
        mainView.tableView.insertRows(at: [IndexPath(row: addresses.count-1, section: 0)], with: .fade)
    }
    
    func setupCallbacks(){
        mainView.header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        mainView.doneBtn.clickCallback = { [weak self] in
            let ind = self?.mainView.tableView.indexPathForSelectedRow
            if ind == nil || ind?.row == self?.addresses.count {
                PopUpLauncher.showErrorMessage(text: "select_address".localized())
                return
            } else {
                self?.selectedAddress?(self?.addresses[ind!.row] ?? "")
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension SelectAddresVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != addresses.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddressTbCell.id, for: indexPath) as! AddressTbCell
            cell.title.text = addresses[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddAddressFooter.id, for: indexPath) as! AddAddressFooter
            cell.isClosed = isClosed
            cell.addBtn.clickCallback = { [weak self] in
                self?.isClosed = !(self?.isClosed ?? false)
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
            
            cell.addSmallBtn.clickCallback = { [weak self] in
                if cell.addAddress() {
                    self?.setupAdditions()
                    self?.isClosed = !(self?.isClosed ?? false)
                    tableView.reloadRows(at: [tableView.indexPath(for: cell)!], with: .fade)
                }
            }

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == addresses.count { return }
        tableView.cellForRow(at: indexPath)?.isSelected = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
}
