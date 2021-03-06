//
//  TasksVC.swift
//  WhatNow
//
//  Created by Tyler Edwards on 1/7/22.
//

import UIKit
import RealmSwift

class TasksTableVC: UITableViewController {
    
    private var dataSource: TasksTableDataSource? {
        didSet {
            dataSource?.changeDelegate = self
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard dataSource != nil else {
            fatalError("Call a configure method to setup the data source at initialization time.")
        }
        
        // Toolbar
        let addTaskButton = NewTaskButton()
        addTaskButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        
        let addTask = UIBarButtonItem(customView: addTaskButton)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [addTask, spacer]
        
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    @objc func addTask() {
        guard let taskForm = storyboard?.instantiateViewController(withIdentifier: "TaskEditVC") as? TaskEditVC else {
            fatalError("Failed to instantiate TaskFormVC")
        }
        
        if let dataSource = dataSource {
            let listOptions = (0 ..< dataSource.listCount).map { dataSource.list(at: $0)}
            taskForm.listOptions = listOptions
        }
        
        let nav = UINavigationController(rootViewController: taskForm)
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true)
    }
    
}

extension TasksTableVC: TasksTableDataSourceChangeDelegate {
    
    func initial() {
        tableView.reloadData()
    }
    
    func update(section: Int, deletions: [Int], insertions: [Int], modifications: [Int]) {
        tableView.performBatchUpdates({
            tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: section) }),
                                 with: .automatic)
            tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: section) }),
                                 with: .automatic)
            tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: section) }),
                                 with: .automatic)
        })
    }
    
}

//MARK: UITableViewDataSource

extension TasksTableVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.listCount ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.taskCount(for: section) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dataSource = dataSource else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.ID, for: indexPath) as? TaskCell
        else {
            fatalError("Couldn't dequeue \(TaskCell.ID)")
        }

        let list = dataSource.list(at: indexPath.section)
        let task = dataSource.task(at: indexPath)
        cell.status = task.status
        cell.statusButton.tintColor = list.color.uiColor
        cell.title.text = task.name
        cell.statusTappedCallback = {
            task.tickStatus()
            cell.status = task.status
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        dataSource?.remove(at: indexPath)
    }
    
}

//MARK: UITableViewDelegate

extension TasksTableVC {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let dataSource = self.dataSource else { return nil }
        guard dataSource.listCount > 1 else { return nil }
        
        let label = UILabel()
        
        let list = dataSource.list(at: section)
        label.font = .systemFont(ofSize: 20)
        label.text = list.name
        label.textColor = list.color.uiColor
        
        return label
    }
    
}

//MARK: Configuration

extension TasksTableVC {
    
    func configure(with list: TaskList) {
        self.dataSource = ListDataSource(lists: [list])
        
        guard navigationController != nil else {
            fatalError("TasksTable should be configured after being added to a navigation controller.")
        }
        
        title = list.name
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: list.color.uiColor]
    }
    
    func configure(with smartList: SmartListDataSource) {
        self.dataSource = smartList
        
        guard navigationController != nil else {
            fatalError("TasksTable should be configured after being added to a navigation controller.")
        }
        
        title = smartList.name
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: smartList.color.uiColor]
    }
    
}
