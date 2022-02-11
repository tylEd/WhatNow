//
//  ListsVC.swift
//  WhatNow
//
//  Created by Tyler Edwards on 1/7/22.
//

import UIKit
import CoreData
import Combine
import RealmSwift

class ListsTableVC: UITableViewController {
    
    var dataSource: ListsTableDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDataSource()
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        // Toolbar
        //TODO: Setup toolbar items in the storyboard.
        //TODO: How to do this with a custom view that has image and text on the button?
        var addTaskConfig = UIButton.Configuration.plain()
        addTaskConfig.image = UIImage(systemName: "plus.circle.fill")
        addTaskConfig.imagePadding = 8
        addTaskConfig.contentInsets = .init(top: 5, leading: 0, bottom: 5, trailing: 5)
        let addTaskButton = UIButton(configuration: addTaskConfig, primaryAction: nil)
        addTaskButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        addTaskButton.setTitle("New Task", for: .normal)
        let addTask = UIBarButtonItem(customView: addTaskButton)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let addList = UIBarButtonItem(title: "Add List", style: .plain, target: self, action: #selector(addList))
        toolbarItems = [addTask, spacer, addList]
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    func setupDataSource() {
        dataSource = ListsTableDataSource()
        dataSource.didLoad = { [unowned self] in tableView.reloadData() }
        
        dataSource.didDelete = { [unowned self] deletions in
            guard deletions.count > 0 else { return } //TODO: Not sure why empty array causes crash.
            tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }),
                                 with: .automatic)
        }
        dataSource.didInsert = { [unowned self] insertions in
            tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                 with: .automatic)
        }
        dataSource.didChange = { [unowned self] modifications in
            tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                 with: .automatic)
        }
        
        tableView.dataSource = dataSource
    }
    
    @objc func addList() {
        guard let listForm = storyboard?.instantiateViewController(withIdentifier: "ListEditVC") as? ListEditVC else {
            fatalError("Failed to instantiate ListFormVC")
        }
        
        listForm.delegate = self
        
        let nav = UINavigationController(rootViewController: listForm)
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true)
    }
    
    @objc func addTask() {
        print("TODO: Add task sheet")
    }
    
}

//MARK: Delegate

extension ListsTableVC {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.isEditing {
            showListEdit(for: indexPath)
        } else {
            pushDetail(for: indexPath)
        }
    }
    
    func pushDetail(for indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "TasksTableVC") as? TasksTableVC {
            vc.list = dataSource.list(at: indexPath.row)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showListEdit(for indexPath: IndexPath) {
        guard let listForm = storyboard?.instantiateViewController(withIdentifier: "ListEditVC") as? ListEditVC else {
            fatalError("Failed to instantiate ListFormVC")
        }
        
        listForm.delegate = self
        listForm.setList(dataSource.list(at: indexPath.row))
        
        let nav = UINavigationController(rootViewController: listForm)
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true)
    }

}

extension ListsTableVC: ListEditVCDelegate {
    
    func didTapDone(list: TaskList) {
        guard list.realm == nil else { return }
        dataSource.addOrUpdate(list)
    }
    
}
