//
//  AreaDetailVC.swift
//  WhatNow
//
//  Created by Tyler Edwards on 1/7/22.
//

import UIKit

class AreaDetailVC: UITableViewController {
    
    var area: Area!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = area.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
    }
    
    @objc func addTask() {
        let ac = UIAlertController(title: "New Task", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { /*[weak self]*/ _ in
            if let name = ac.textFields?[0].text {
                self.area.tasks.append(Task(name: name))
                DispatchQueue.main.async {
                    self.tableView.insertRows(at: [IndexPath(row: self.area.tasks.count - 1, section: 0)], with: .right)
                }
            }
        }))
        
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return area.tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        let task = area.tasks[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = task.name
        cell.contentConfiguration = content
        
        return cell
    }

}
