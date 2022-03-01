//
//  ListFormVC.swift
//  WhatNow
//
//  Created by Tyler Edwards on 1/13/22.
//

import UIKit

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
    var didCommitChanges: ((TaskList) -> Void)?
    
    func setList(_ list: TaskList) {
        editList = TaskList(value: list)
        editList.id = list.id //NOTE: id needed for updates. Not copied by default.
        tableView.reloadData()
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
            didCommitChanges?(editList)
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
            cell.frame = tableView.bounds
            cell.collectionView.reloadData()
            cell.layoutIfNeeded()
            cell.collectionViewHeight.constant = cell.collectionView.collectionViewLayout.collectionViewContentSize.height
            
            cell.setSelectedColorIndex(newValue: editList.color.rawValue)
            cell.didChangeColor = { [unowned self] color in
                self.editList.set(color: color)
                tableView.reloadSections([ListEditSection.title.rawValue], with: .none)
            }
        }
        
        if let cell = cell as? IconSelectCell {
            cell.frame = tableView.bounds
            cell.collectionView.reloadData()
            cell.layoutIfNeeded()
            cell.collectionViewHeight.constant = cell.collectionView.collectionViewLayout.collectionViewContentSize.height
            
            cell.selectedIconIndex = TaskList.Icon.allCases.firstIndex(of: editList.icon)!
            cell.didChangeIcon = { [unowned self] icon in
                self.editList.set(icon: icon)
                tableView.reloadSections([ListEditSection.title.rawValue], with: .none)
            }
        }
        
        return cell
    }
    
}
