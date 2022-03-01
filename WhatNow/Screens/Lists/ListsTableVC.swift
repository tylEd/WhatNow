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
        
        self.dataSource = ListsTableDataSource()
        self.dataSource.changeDelegate = self
        tableView.dataSource = dataSource
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        // Toolbar
        let addTaskButton = NewTaskButton()
        addTaskButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        
        let addTask = UIBarButtonItem(customView: addTaskButton)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let addList = UIBarButtonItem(title: "Add List", style: .plain, target: self, action: #selector(addList))
        toolbarItems = [addTask, spacer, addList]
        
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @objc func addList() {
        showListEditView()
    }
    
    @objc func addTask() {
        guard let taskForm = storyboard?.instantiateViewController(withIdentifier: "TaskEditVC") as? TaskEditVC else {
            fatalError("Failed to instantiate TaskFormVC")
        }
        
        taskForm.listOptions = Array(dataSource.taskLists)
        
        let nav = UINavigationController(rootViewController: taskForm)
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true)
    }
    
    func pushTasksList(for list: TaskList) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "TasksTableVC") as? TasksTableVC {
            navigationController?.pushViewController(vc, animated: true)
            vc.configure(with: list)
        }
    }
    
    func pushSmartList(for smartList: SmartListDataSource) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "TasksTableVC") as? TasksTableVC {
            navigationController?.pushViewController(vc, animated: true)
            vc.configure(with: smartList)
        }
    }
    
    func showListEditView(for list: TaskList? = nil) {
        guard let listForm = storyboard?.instantiateViewController(withIdentifier: "ListEditVC") as? ListEditVC else {
            fatalError("Failed to instantiate ListFormVC")
        }
        
        listForm.didCommitChanges = { [unowned self] list in
            guard list.realm == nil else { return }
            self.dataSource.addOrUpdate(list)
        }
        
        if let list = list {
            listForm.setList(list)
        }
        
        let nav = UINavigationController(rootViewController: listForm)
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true)
    }

}

//MARK: Data Source Change Delegate

extension ListsTableVC: ListsTableDataSourceChangeDelegate {
    
    func initial() {
        tableView.reloadData()
    }
    
    func update(deletions: [Int], insertions: [Int], modifications: [Int]) {
        tableView.performBatchUpdates({
            tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 1) }),
                                 with: .automatic)
            tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 1) }),
                                 with: .automatic)
            tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 1) }),
                                 with: .automatic)
        })
    }
    
}

//MARK: UITableViewDelegate

extension ListsTableVC {
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 0 {
            return .none
        }
        
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let smartList = SmartLists.all[indexPath.row]
            pushSmartList(for: smartList)
            return
        }
        
        if tableView.isEditing {
            showListEditView(for: dataSource.list(at: indexPath.row))
        } else {
            pushTasksList(for: dataSource.list(at: indexPath.row))
        }
    }
    
}
