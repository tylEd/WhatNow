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

class ListsVC: UITableViewController {
    
    var model = Model()
    var notificationToken: NotificationToken!
    
    deinit {
        notificationToken.invalidate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupModelObserver()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: nil)
        
        // Toolbar
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
        navigationController?.isToolbarHidden = false
    }
    
    func setupModelObserver() {
        notificationToken = model.lists.observe { [weak self] (changes) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView.
                tableView.performBatchUpdates({
                    // It's important to be sure to always update a table in this order:
                    // deletions, insertions, then updates. Otherwise, you could be unintentionally
                    // updating at the wrong index!
                    tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }),
                        with: .automatic)
                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                        with: .automatic)
                    tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                        with: .automatic)
                })
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    @objc func addList() {
        guard let nav = storyboard?.instantiateViewController(withIdentifier: "ListEditVC") as? UINavigationController,
              let listForm = nav.viewControllers[0] as? ListEditVC
        else {
            fatalError("Failed to instantiate ListFormVC")
        }
        
        listForm.delegate = self
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true)
    }
    
    @objc func addTask() {
        print("TODO: Add task sheet")
    }
    
}

//MARK: Data Source

extension ListsVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        let list = model.lists[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = list.name + " \(list.tasks.count)"
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "TasksVC") as? TasksVC {
            vc.list = model.lists[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let list = model.lists[indexPath.row]
        model.deleteList(id: list.id)
    }

}

extension ListsVC: ListEditVCDelegate {
    
    func didTapDone(list: TaskList) {
        model.addList(name: list.name)
    }
    
}
