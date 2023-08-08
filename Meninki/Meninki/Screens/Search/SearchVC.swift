//
//  SearchVC.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 17.05.2023.
//

import UIKit

class SearchVC: UIViewController {
    
    let data = AccUserDefaults.searchHistory
    
    var mainView: SearchView {
        return view as! SearchView
    }
    
    override func loadView() {
        super.loadView()
        view = SearchView()
        view.backgroundColor = .bg
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.addObserver()
        mainView.search.textField.becomeFirstResponder()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        setupCallbacks()
    }
    
    func setupCallbacks(){
//        mainView.search.didBeginEditingCallback = { [weak self] in
//            self?.mainView.doneBtn.isEnabled = true
//        }
        
        mainView.doneBtn.clickCallback = { [weak self] in
            self?.saveSearchTextAndOpenResults(self?.mainView.search.textField.text)
        }
        
        mainView.header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func saveSearchTextAndOpenResults(_ text: String?){
        guard let search = text else { return }
        if search.isEmpty { return }
        var searchHistory = AccUserDefaults.searchHistory
        searchHistory.removeAll(where: ({ $0 == search }))
        searchHistory.insert(search, at: 0)
        
        if searchHistory.count > 5 {
            AccUserDefaults.searchHistory = Array(searchHistory[0...4])

        } else {
            AccUserDefaults.searchHistory = searchHistory
        }
        
        let vc = ProductListVC()
        vc.viewModel.params.search = search
        vc.mainView.setupWithSearch()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTbCell.id, for: indexPath) as! SearchTbCell
        cell.title.text = data[indexPath.row]
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        saveSearchTextAndOpenResults(data[indexPath.row])
    }
}
