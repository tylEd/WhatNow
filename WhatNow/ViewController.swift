//
//  ViewController.swift
//  WhatNow
//
//  Created by Tyler Edwards on 1/7/22.
//

import UIKit

class ViewController: UITableViewController {
    
    var model = Model()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.loadTestDate()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addArea))
    }
    
    @objc func addArea() {
        let ac = UIAlertController(title: "New Area", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { /*[weak self]*/ _ in
            if let name = ac.textFields?[0].text {
                self.model.lists.append(List(name: name, color: .green))
                DispatchQueue.main.async {
                    self.tableView.insertRows(at: [IndexPath(row: self.model.lists.count - 1, section: 0)], with: .right)
                }
            }
        }))
        
        present(ac, animated: true)
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
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ListVC") as? ListVC {
            vc.list = model.lists[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

