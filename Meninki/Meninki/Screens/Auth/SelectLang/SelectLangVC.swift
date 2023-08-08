//
//  SelectLangVC.swift
//  Meninki
//
//  Created by Shirin on 3/29/23.
//

import UIKit

class SelectLangVC: UIViewController {

    var data: [String] = []
    var desc: [String] = []
    var didSelectAtInd: ( (Int)->() )?
    
    var mainView: ListView {
        return view as! ListView
    }

    override func loadView() {
        super.loadView()
        view = ListView()
        view.backgroundColor = .bg
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
}

extension SelectLangVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTbCell.id, for: indexPath) as! ListTbCell
        cell.setupData(title: data[indexPath.row],
                       desc: desc.count > 0 ? desc[indexPath.row] : nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectAtInd?(indexPath.row)
        navigationController?.popViewController(animated: true)
    }
}
