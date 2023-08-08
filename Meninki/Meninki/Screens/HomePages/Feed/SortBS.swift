//
//  SortBS.swift
//  Meninki
//
//  Created by Shirin on 4/22/23.
//

import UIKit

class SortBS: UIViewController {

    var selectionCallback: ( (SortType.RawValue)->() )?
    var mainView: BottomSheetView {
        return view as! BottomSheetView
    }

    override func loadView() {
        super.loadView()
        view = BottomSheetView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.title.text = "sort_type".localized()
        mainView.desc.text = ""
        createBtns()
    }
    
    func createBtns(){
        SortType.allValues.forEach { value in
            let b = BottomSheetBtn(title: SortType.allTitles[value], icon: nil)
            b.clickCallback = { [weak self] in
                self?.selectionCallback?(value)
                self?.dismiss(animated: true)
            }
            
            mainView.btnStack.addArrangedSubview(b)
        }
    }
}
