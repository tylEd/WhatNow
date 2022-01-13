//
//  ListsVC.swift
//  WhatNow
//
//  Created by Tyler Edwards on 1/7/22.
//

import UIKit
import CoreData

class ListsVC: UITableViewController {
    
    var model = Model()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.loadTestDate()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addList))
    }
    
    @objc func addList() {
        guard let nav = storyboard?.instantiateViewController(withIdentifier: "ListFormVC") as? UINavigationController,
              let listForm = nav.viewControllers[0] as? ListFormVC
        else {
            fatalError("Failed to instantiate ListFormVC")
        }
        
        listForm.delegate = self
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true)
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

extension ListsVC: ListFormVCDelegate {
    
    func didTapDone(list: List) {
        model.lists.append(list)
        tableView.insertRows(at: [IndexPath(row: model.lists.count - 1, section: 0)], with: .right)
    }
    
}
