//
//  TasksVC.swift
//  WhatNow
//
//  Created by Tyler Edwards on 1/7/22.
//

import UIKit
import RealmSwift

class TasksTableVC: UITableViewController {
    
    private var lists: [TaskList] = []
    private var dataSource: UITableViewDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupDataSource()
    }
    
    func setupDataSource() {
        let dataSource = TasksTableDataSource(lists: lists)
        
        dataSource.didLoad = { [unowned self] in tableView.reloadData() }
        
        dataSource.didDelete = { [unowned self] (section, deletions) in
            guard deletions.count > 0 else { return } //TODO: Not sure why empty array causes crash.
            tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: section) }),
                                 with: .automatic)
        }
        dataSource.didInsert = { [unowned self] (section, insertions) in
            tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: section) }),
                                 with: .automatic)
        }
        dataSource.didChange = { [unowned self] (section, modifications) in
            tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: section) }),
                                 with: .automatic)
        }
        
        self.dataSource = dataSource
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
    }
    
    @objc func addTask() {
        let ac = UIAlertController(title: "New Task", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { /*[weak self]*/ _ in
            if let name = ac.textFields?[0].text {
                //***********************************************************
                //TODO: Adding items is broken now. What list to add them to?
                //***********************************************************
                self.lists[0].add(task: Task(value: ["name": name]))
            }
        }))
        
        present(ac, animated: true)
    }
    
    @objc func editSchedule() {
    }
    
}

//MARK: Configuration

extension TasksTableVC {
    //TODO: Should these be subclasses? Not sure how to do that in storyboard.
    //      If smart lists follow a similar protocol to TaskList then no. Just configure from the protocol type.
    //      New task will open the sheet when there are multiple lists.
    //      Might add the TextField cells as well.
    
    func configure(with list: TaskList) {
        self.lists = [list]
        setupDataSource()
        
        guard navigationController != nil else {
            fatalError("TasksTable should be configured after being added to a navigation controller.")
        }
        
        title = list.name
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: list.color.uiColor]
    }
    
    func configure(with smartList: SmartList) {
        let dataSource = TasksTableSmartDataSource(smartList: smartList)
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        self.dataSource = dataSource
        
        guard navigationController != nil else {
            fatalError("TasksTable should be configured after being added to a navigation controller.")
        }
        
        title = smartList.name
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: smartList.color.uiColor]
        
        //TODO: This is specific to one SmartList. How can I handle that gracefully?
        // Toolbar
        let addTask = createNewTaskBarButtonItem()
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let editSchedule = UIBarButtonItem(title: "Edit Schedule", style: .plain, target: self, action: #selector(editSchedule))
        toolbarItems = [addTask, spacer, editSchedule]
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    private func createNewTaskBarButtonItem() -> UIBarButtonItem {
        //TODO: Copied
        //TODO: Should this be a subclass
        var addTaskConfig = UIButton.Configuration.plain()
        addTaskConfig.image = UIImage(systemName: "plus.circle.fill")
        addTaskConfig.imagePadding = 8
        addTaskConfig.contentInsets = .init(top: 5, leading: 0, bottom: 5, trailing: 5)
        
        let addTaskButton = UIButton(configuration: addTaskConfig, primaryAction: nil)
        addTaskButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        addTaskButton.setTitle("New Task", for: .normal)
        
        let addTask = UIBarButtonItem(customView: addTaskButton)
        return addTask
    }
    
}
