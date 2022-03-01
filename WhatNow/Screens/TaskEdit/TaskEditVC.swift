//
//  TaskEditVC.swift
//  WhatNow
//
//  Created by Tyler Edwards on 2/24/22.
//

import UIKit

class TaskEditVC: UITableViewController {
    
    enum Section: Int, CaseIterable {
        case Name
        case ListPicker
    }
    
    var name: String = ""
    var selectedList: TaskList?
    
    var listOptions: [TaskList] = [] {
        didSet {
            tableView.reloadRows(at: [IndexPath(row: 0, section: Section.ListPicker.rawValue)], with: .none)
            if listOptions.count > 0 {
                selectedList = listOptions[0]
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    }
    
    @objc func cancel() {
        dismiss(animated: true)
    }
    
    @objc func done(selectedList: TaskList) {
        guard let selectedList = self.selectedList,
              name != ""
        else {
            let ac = UIAlertController(title: "Incomplete Form", message: "A task must have a name.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
            
            return
        }

        if let realm = selectedList.realm {
            let task = Task(name: name)
            try? realm.write {
                selectedList.tasks.append(task)
            }
        }
        
        dismiss(animated: true)
    }
    
}

extension TaskEditVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { fatalError() }
        
        switch section {
        case .Name:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskNameCell.ID, for: indexPath) as? TaskNameCell else {
                fatalError()
            }
            
            cell.textDidChange = { newName in
                self.name = newName
            }
            return cell
        case .ListPicker:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskListPickerCell.ID, for: indexPath) as? TaskListPickerCell else {
                fatalError()
            }
            
            cell.configure(with: listOptions)
            cell.didChangeSelection = { [unowned self] list in
                self.selectedList = list
            }
            
            return cell
        }
    }

}
