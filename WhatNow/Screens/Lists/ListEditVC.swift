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
    
    var list = TaskList(value: ["name": ""])
    var delegate: ListEditVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
    }
    
    @objc func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc func doneTapped() {
//        if let title = titleField.text,
//           title != ""
//        {
//            list.name = title
//            delegate?.didTapDone(list: list)
//            dismiss(animated: true)
//        }
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
        if let cell = cell as? ColorSelectCell {
            //cell.frame = tableView.bounds;
            //cell.collectionView.reloadData()
            //cell.layoutIfNeeded()
            //TODO: Probably not necessary here, since the content is static, but other layouts might need to
            //      be able to call this everytime the collection data reloads or the size changes.
            cell.collectionViewHeight.constant = cell.collectionView.collectionViewLayout.collectionViewContentSize.height
        }
        if let cell = cell as? IconSelectCell {
            //cell.frame = tableView.bounds;
            //cell.collectionView.reloadData()
            //cell.layoutIfNeeded()
            //TODO: Probably not necessary here, since the content is static, but other layouts might need to
            //      be able to call this everytime the collection data reloads or the size changes.
            cell.collectionViewHeight.constant = cell.collectionView.collectionViewLayout.collectionViewContentSize.height
        }
        return cell
    }
    
}
