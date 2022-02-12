//
//  TasksVC.swift
//  WhatNow
//
//  Created by Tyler Edwards on 1/7/22.
//

import UIKit
import RealmSwift

class TasksTableVC: UITableViewController {
    
    var list: TaskList?
    var dataSource: TasksTableDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let list = list else { return }
        
        setupDataSource()
        
        title = list.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
    }
    
    func setupDataSource() {
        guard let list = list else { return }
        
        let dataSource = TasksTableDataSource(list: list)
        
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
        
        self.dataSource = dataSource
        tableView.dataSource = dataSource
    }
    
    @objc func addTask() {
        let ac = UIAlertController(title: "New Task", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { /*[weak self]*/ _ in
            if let name = ac.textFields?[0].text {
                self.list?.add(task: Task(value: ["name": name]))
            }
        }))
        
        present(ac, animated: true)
    }
    
}
