//
//  AddOptionVC.swift
//  Meninki
//
//  Created by Ширин Янгибаева on 06.05.2023.
//

import UIKit
import TLPhotoPicker

class AddOptionVC: UIViewController {
    
    weak var parentVC: AddProductVC?

    var viewModel = AddOptionsVM()
    
    var addOptionToIndex = -1
    var currentAddOption: Option?
    
    var images: [UploadImage] = []
    
    var options: [[Option]] = []
    var optionTitles: [String] = []
    var optionTypes: [OptionType] = []
    
    var optionsCreated = false
    var imagesAdded = false
    var toUpdate: Bool = false

    let sheetTransitioningDelegate = SheetTransitioningDelegate()
    
    var mainView: AddOptionView {
        return view as! AddOptionView
    }
    
    override func loadView() {
        super.loadView()
        view = AddOptionView()
        view.backgroundColor = .bg
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        setupBindings()
        setupCallbacks()
    }
    
    func setupBindings(){
        viewModel.inProgress.bind { [weak self] toShow in
            self?.mainView.loading(toShow)
        }
        
        viewModel.optionsAdded.bind { [weak self] success in
            if success == false { return }
            if self?.images.isEmpty == true {
                self?.viewModel.getPersonalChars()
            } else {
                self?.viewModel.addImages(images: self?.images ?? [])
            }
        }
        
        viewModel.imgAdded.bind { [weak self] success in
            if success == false { return }
            self?.viewModel.getPersonalChars()
        }
        
        viewModel.personalChars.bind { [weak self] value in
            if value == nil { return }
            self?.parentVC?.personalChars = value ?? []
            self?.parentVC?.options = self?.options ?? []
            self?.parentVC?.optionTypes = self?.optionTypes ?? []
            self?.parentVC?.optionTitles = self?.optionTitles ?? []
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func setupCallbacks(){
        mainView.header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        mainView.addOptionBtn.clickCallback = { [weak self] in
            self?.openOptionBS()
        }
        
        mainView.doneBtn.clickCallback = { [weak self] in
            if self?.toUpdate == true {
                self?.navigationController?.popViewController(animated: true)
            } else {
                guard let data = self?.getData() else { return }
                self?.viewModel.addOptions(params: data)
            }
        }
    }
    
    func getData() -> AddOptions? {
        var options: [[Option]] = []
        var titles: [String] = []
        
        self.options.enumerated().forEach { (ind, option) in
            if option.isEmpty == false {
                options.append(option)
                titles.append(optionTitles[ind])
            }
        }
        
        return options.isEmpty ? nil : AddOptions(options: options, optionTitles: titles)
    }
    
    func openOptionBS(){
        let vc = OptionsBS()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = sheetTransitioningDelegate
        vc.textBtn.clickCallback = { [weak self] in
            vc.dismiss(animated: true)
            self?.createEmptyOption(type: .text)
        }
        
        vc.imgBtn.clickCallback = { [weak self] in
            vc.dismiss(animated: true)
            self?.createEmptyOption(type: .image)
        }
        present(vc, animated: true)
    }
    
    func createEmptyOption(type: OptionType){
        addOptionToIndex = optionTitles.count
        optionTitles.append("\(type)".localized())
        optionTypes.append(type)
        options.append(contentsOf: [[]])
        
        print(options)
        openEnterTextVC(addTitle: true)
    }
    
    func createOption(optionInd: Int){
        currentAddOption = Option(id: UUID().uuidString,
                                  optionLevel: optionInd,
                                  optionType: optionTypes[optionInd].rawValue,
                                  productId: viewModel.productId)
        if optionTypes[optionInd] == .text {
            openEnterTextVC()
        } else {
            openPicker()
        }
    }
    
    func addOption(){
        guard let option = currentAddOption else { return }
        currentAddOption = nil
        let ind = option.optionLevel ?? 0
        options[ind].insert(option, at: 0)
        print(options)
        mainView.tableView.reloadData()
    }
    
    func openEnterTextVC(addTitle: Bool = false){
        let vc = EnterTextVC()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.mainView.textfield.textField.text = addTitle ? optionTitles[addOptionToIndex] : ""
        vc.mainView.doneBtn.clickCallback = { [weak self] in
            let value = vc.mainView.textfield.textField.text
            if addTitle {
                self?.optionTitles[self?.addOptionToIndex ?? 0 ] = value ?? ""
                self?.mainView.tableView.reloadData()
            } else {
                self?.currentAddOption?.value = value
                self?.addOption()
            }
            vc.dismiss(animated: true)
        }
        
        self.present(vc, animated: true)
    }
    
    func openPicker(){
        let imgPicker = TLPhotosPickerViewController()
        imgPicker.configure.singleSelectedMode = true
        imgPicker.delegate = self
        present(imgPicker, animated: true)
    }
}

extension AddOptionVC: TLPhotosPickerViewControllerDelegate {
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        guard let first = withTLPHAssets.first else { return }
        let img = UploadImage(objectId: currentAddOption?.id ?? "",
                              isAvatar: false,
                              imageType: ImageType.option.rawValue,
                              width: first.phAsset?.pixelWidth,
                              height: first.phAsset?.pixelHeight,
                              filename: first.originalFileName,
                              data: first.fullResolutionImage?.jpegData(compressionQuality: 0.75))
        images.append(img)
        addOption()
    }
}


extension AddOptionVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if optionTypes[indexPath.row] == .image {
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageOptionListTbCell.id, for: indexPath) as! ImageOptionListTbCell
            cell.withAdd = !toUpdate
            cell.hideEditBtns()
            cell.title.text = optionTitles[indexPath.row]
            cell.data = options[indexPath.row]
            cell.images = images
            cell.addClickCallback = { [weak self] in
                self?.createOption(optionInd: indexPath.row)
            }
            
            cell.deleteClickCallback = { [weak self] ind in
                if self?.options[indexPath.row].count ?? 0 > ind {
                    let id = self?.options[indexPath.row][ind].id ?? ""
                    self?.images.removeAll(where: {$0.objectId == id})
                    self?.options[indexPath.row].remove(at: ind)
                    cell.data = self?.options[indexPath.row] ?? []
                    cell.images = self?.images ?? []
                    cell.collectionView.reloadData()
                }
            }
            
            cell.deleteBtn.clickCallback = { [weak self] in
                if self?.optionTypes.count ?? 0 > indexPath.row {
                    self?.options.remove(at: indexPath.row)
                    self?.optionTitles.remove(at: indexPath.row)
                    self?.optionTypes.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
            
            cell.editBtn.clickCallback = { [weak self] in
                self?.addOptionToIndex = indexPath.row
                self?.openEnterTextVC(addTitle: true)
            }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ValueOptionListTbCell.id, for: indexPath) as! ValueOptionListTbCell
            cell.withAdd = !toUpdate
            cell.hideEditBtns()
            cell.title.text = optionTitles[indexPath.row]
            cell.data = options[indexPath.row]
            cell.addClickCallback = { [weak self] in
                self?.createOption(optionInd: indexPath.row)
            }
            
            cell.deleteClickCallback = { [weak self] ind in
                if self?.options[indexPath.row].count ?? 0 > ind {
                    self?.options[indexPath.row].remove(at: ind)
                    cell.data = self?.options[indexPath.row] ?? []
                    cell.collectionView.reloadData()
                }
            }
            
            cell.deleteBtn.clickCallback = { [weak self] in
                if self?.optionTypes.count ?? 0 > indexPath.row {
                    self?.options.remove(at: indexPath.row)
                    self?.optionTitles.remove(at: indexPath.row)
                    self?.optionTypes.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
            
            cell.editBtn.clickCallback = { [weak self] in
                self?.addOptionToIndex = indexPath.row
                self?.openEnterTextVC(addTitle: true)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if toUpdate { return nil }
        return mainView.tableViewFooter
    }
}
