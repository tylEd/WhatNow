//
//  TasksVC.swift
//  WhatNow
//
//  Created by Tyler Edwards on 1/7/22.
//

import UIKit
import RealmSwift

class TasksTableVC: UITableViewController {
    
    var lists: [TaskList] = []
    var dataSource: TasksTableDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDataSource()
        
        if lists.count == 1 {
            let list = lists[0]
            title = list.name
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:uiColor(for: list.color)]
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
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
                self.lists[-1].add(task: Task(value: ["name": name]))
            }
        }))
        
        present(ac, animated: true)
    }
    
}
