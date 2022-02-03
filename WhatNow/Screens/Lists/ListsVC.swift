//
//  ListsVC.swift
//  WhatNow
//
//  Created by Tyler Edwards on 1/7/22.
//

import UIKit
import CoreData
import Combine

class ListsVC: UITableViewController {
    
    var model = Model()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        let area = model.lists[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = area.name
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "TasksVC") as? TasksVC {
            vc.list = model.lists[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

extension ListsVC: ListEditVCDelegate {
    
    func didTapDone(list: TaskList) {
//        model.lists.append(list)
//        tableView.insertRows(at: [IndexPath(row: model.lists.count - 1, section: 0)], with: .right)
        model.addList(name: list.name)
        tableView.reloadData()
    }
    
}
