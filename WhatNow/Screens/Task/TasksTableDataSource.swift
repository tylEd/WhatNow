//
//  TasksTableDataSource.swift
//  WhatNow
//
//  Created by Tyler Edwards on 2/11/22.
//

import UIKit
import RealmSwift

class TasksTableDataSource: NSObject {
    
    private var list: TaskList
    private var notificationToken: NotificationToken!
    
    //TODO: Should I collapse these into something like the observe changes enum?
    //      Having them indiviually passed like this prevents batch updates on the TableView.
    //      tableView.performBatchUpdates({})
    var didLoad: (() -> Void)?
    var didDelete: (([Int]) -> Void)?
    var didInsert: (([Int]) -> Void)?
    var didChange: (([Int]) -> Void)?
    
    init(list: TaskList) {
        self.list = list
        
        super.init()
        
        setupNotifications()
    }
    
    deinit {
        notificationToken.invalidate()
    }
    
    func setupNotifications() {
        //TODO: I would prefer for this to just get changes to the List, but now sure how currently.
        //      Might be as simple as ignoring modifications. Need to check that moves don't trigger that before I remove it. 
        notificationToken = list.tasks.observe(keyPaths: ["name"]) { [unowned self] (changes) in
            switch changes {
            case .initial:
                didLoad?()
            case .update(_, let deletions, let insertions, let modifications):
                didDelete?(deletions)
                didInsert?(insertions)
                didChange?(modifications)
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
}
    
//MARK: TableView Data Source

extension TasksTableDataSource: UITableViewDataSource {
    
    //TODO: Could I store ID's on the Cell classes themselves
    static let taskCellID = "TaskCell"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.taskCellID, for: indexPath) as? TaskCell
        else {
            fatalError("Couldn't dequeue \(Self.taskCellID)")
        }
        
        let task = list.tasks[indexPath.row]
        cell.statusButton.setBackgroundImage(task.status.imageForStatus(), for: .normal)
        cell.statusButton.tintColor = uiColor(for: list.color)
        cell.title.text = task.name
        cell.statusTappedCallback = {
            task.tickStatus()
            cell.statusButton.setBackgroundImage(task.status.imageForStatus(), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        if let realm = list.realm {
            try? realm.write {
                list.tasks.remove(at: indexPath.row)
            }
        } else {
            list.tasks.remove(at: indexPath.row)
        }
    }
    
}

extension Task.Status {
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
