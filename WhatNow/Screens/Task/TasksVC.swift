//
//  TasksVC.swift
//  WhatNow
//
//  Created by Tyler Edwards on 1/7/22.
//

import UIKit

class TasksVC: UITableViewController {
    
    var list: TaskList!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = list.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
    }
    
    @objc func addTask() {
        let ac = UIAlertController(title: "New Task", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { /*[weak self]*/ _ in
            if let name = ac.textFields?[0].text {
                //TODO: This crashes
                self.list.tasks.append(Task(value: ["name": name]))
                DispatchQueue.main.async {
                    self.tableView.insertRows(at: [IndexPath(row: self.list.tasks.count - 1, section: 0)], with: .right)
                }
            }
        }))
        
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell
        else {
            fatalError("Couldn't dequeue TaskCell")
        }
        let task = list.tasks[indexPath.row]
        
        cell.toggle.imageView?.image = task.status.imageForStatus()
        cell.title.text = task.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let task = list.tasks[indexPath.row]
        task.status = task.status.next()
        if let cell = tableView.cellForRow(at: indexPath) as? TaskCell {
            cell.toggle.imageView?.image = task.status.imageForStatus()
        }
    }

}

fileprivate extension Task.Status {
    func imageForStatus() -> UIImage? {
        switch self {
        case .Scheduled:
            //return UIImage(systemName: "circle")
            return UIImage(systemName: "circle.dotted")
        case .InProgress:
            //return UIImage(systemName: "circle.lefthalf.filled")
            return UIImage(systemName: "circle")
        case .Completed:
            return UIImage(systemName: "circle.fill")
        }
    }
}
