//
//  ListFormVC.swift
//  WhatNow
//
//  Created by Tyler Edwards on 1/13/22.
//

import UIKit

protocol ListEditVCDelegate {
    func didTapDone(list: TaskList)
}

class ListEditVC: UITableViewController {
    
    enum ListEditSection: Int, CaseIterable {
        case title
        case color
        case icon
        
        func cellIdentifier() -> String {
            switch self {
            case .title:
                return "TitleCell"
            case .color:
                return "ColorSelectCell"
            case .icon:
                return "IconSelectCell"
            }
        }
    }
    
    private var editList = TaskList(value: ["name": ""])
    var delegate: ListEditVCDelegate?
    
    func setList(_ list: TaskList) {
        editList = TaskList(value: list)
        editList.id = list.id //NOTE: id needed for updates. Not copied by default.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
    }
    
    @objc func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc func doneTapped() {
        if editList.name != "" {
            delegate?.didTapDone(list: editList)
            dismiss(animated: true)
        }
    }
    
}

//MARK: TableView Delegate and DataSource

extension ListEditVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ListEditSection.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = ListEditSection(rawValue: indexPath.section) else {
            fatalError("Section index out of range")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier(), for: indexPath)
        if let cell = cell as? TitlePreviewCell {
            cell.configure(color: editList.color.uiColor, imageSystemName: editList.icon.rawValue, name: editList.name)
            cell.didChangeName = { [unowned self] newName in
                self.editList.name = newName
            }
        }
        
        if let cell = cell as? ColorSelectCell {
            //TODO: Might want this to be a CollectionView subclass.
            cell.frame = tableView.bounds //TODO: Figure out why this fixes it.
            cell.collectionView.reloadData()
            cell.layoutIfNeeded()
            //TODO: Probably not necessary here, since the content is static, but other layouts might need to
            //      be able to call this everytime the collection data reloads or the size changes.
            cell.collectionViewHeight.constant = cell.collectionView.collectionViewLayout.collectionViewContentSize.height
            
            cell.selectedColorIndex = editList.color.rawValue
            cell.didChangeColor = { [unowned self] color in
                self.editList.setColor(color)
                tableView.reloadSections([ListEditSection.title.rawValue], with: .none)
            }
        }
        
        if let cell = cell as? IconSelectCell {
            cell.frame = tableView.bounds //TODO: Figure out why this fixes it.
            cell.collectionView.reloadData()
            cell.layoutIfNeeded()
            cell.collectionViewHeight.constant = cell.collectionView.collectionViewLayout.collectionViewContentSize.height
            
            cell.selectedIconIndex = TaskList.Icon.allCases.firstIndex(of: editList.icon)! //TODO: !
            cell.didChangeIcon = { [unowned self] icon in
                self.editList.setIcon(icon)
                tableView.reloadSections([ListEditSection.title.rawValue], with: .none)
            }
        }
        
        return cell
    }
    
}
