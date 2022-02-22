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
    }
    
    @objc func addTask() {
        //TODO: Add through a sheet form or textfields in the rows
        let ac = UIAlertController(title: "New Task", message: nil, preferredStyle: .alert)
        ac.addTextField()

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { [unowned self] _ in
            if let name = ac.textFields?[0].text {
                //***********************************************************
                //TODO: Adding items is broken now. What list to add them to?
                //***********************************************************
                self.dataSource?.list(at: 0).add(task: Task(value: ["name": name]))
            }
        }))

        present(ac, animated: true)
    }
    
    @objc func editSchedule() {
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
        cell.statusButton.setBackgroundImage(task.status.imageForStatus(), for: .normal)
        cell.statusButton.tintColor = list.color.uiColor
        cell.title.text = task.name
        cell.statusTappedCallback = {
            task.tickStatus()
            cell.statusButton.setBackgroundImage(task.status.imageForStatus(), for: .normal)
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
    //TODO: Should these be subclasses? Not sure how to do that in storyboard.
    //      If smart lists follow a similar protocol to TaskList then no. Just configure from the protocol type.
    //      New task will open the sheet when there are multiple lists.
    //      Might add the TextField cells as well.
    
    func configure(with list: TaskList) {
        self.dataSource = ListDataSource(lists: [list])
        
        guard navigationController != nil else {
            fatalError("TasksTable should be configured after being added to a navigation controller.")
        }
        
        title = list.name
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: list.color.uiColor]
        
        //TODO: This is specific to one SmartList. How can I handle that gracefully?
        // Toolbar
        let addTask = createNewTaskBarButtonItem()
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [addTask, spacer]
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    func configure(with smartList: SmartList) {
        self.dataSource = SmartListDataSource(smartList: smartList)
        
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

//TODO: Where should this go?
extension Task.Status {
    func imageForStatus() -> UIImage? {
        switch self {
        case .Scheduled:
            return UIImage(systemName: "circle.dotted")
        case .InProgress:
            return UIImage(systemName: "circle")
        case .Completed:
            return UIImage(systemName: "circle.fill")
        }
    }
}
