//
//  TasksTableDataSource.swift
//  WhatNow
//
//  Created by Tyler Edwards on 2/11/22.
//

import UIKit
import RealmSwift

class TasksTableDataSource: NSObject {
    
    private var lists: [TaskList]
    private var notificationTokens: [NotificationToken]
    
    //TODO: Should I collapse these into something like the observe changes enum?
    //      Having them indiviually passed like this prevents batch updates on the TableView.
    //      tableView.performBatchUpdates({})
    typealias Update = (Int, [Int]) -> Void
    var didLoad: (() -> Void)?
    var didDelete: Update?
    var didInsert: Update?
    var didChange: Update?
    
    init(lists: [TaskList]) {
        self.lists = lists
        self.notificationTokens = []
        
        super.init()
        
        setupNotifications()
    }
    
    deinit {
        for token in notificationTokens {
            token.invalidate()
        }
    }
    
    func setupNotifications() {
        self.notificationTokens = []
        for list in lists {
            //TODO: I would prefer for this to just get changes to the List, but now sure how currently.
            //      Might be as simple as ignoring modifications. Need to check that moves don't trigger that before I remove it.
            let notificationToken = list.tasks.observe(keyPaths: ["name"]) { [unowned self] changes in
                switch changes {
                case .initial:
                    didLoad?()
                case .update(_, let deletions, let insertions, let modifications):
                    //TODO: Need to pass the list / section index too.
                    if let section = lists.firstIndex(of: list) {
                        didDelete?(section, deletions)
                        didInsert?(section, insertions)
                        didChange?(section, modifications)
                    }
                case .error(let error):
                    // An error occurred while opening the Realm file on the background worker thread
                    fatalError("\(error)")
                }
            }
            
            self.notificationTokens.append(notificationToken)
        }
    }
    
}
    
//MARK: TableView Data Source

extension TasksTableDataSource: UITableViewDataSource {
    
    //TODO: Could I store ID's on the Cell classes themselves
    static let taskCellID = "TaskCell"
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: *
        return lists[section].tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.taskCellID, for: indexPath) as? TaskCell
        else {
            fatalError("Couldn't dequeue \(Self.taskCellID)")
        }
        
        let list = lists[indexPath.section]
        let task = list.tasks[indexPath.row]
        cell.statusButton.setBackgroundImage(task.status.imageForStatus(), for: .normal)
        //TODO: Add uiColor as a property on TaskList.Color
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
        
        let list = lists[indexPath.section]
        if let realm = list.realm {
            try? realm.write {
                list.tasks.remove(at: indexPath.row)
            }
        } else {
            list.tasks.remove(at: indexPath.row)
        }
    }
    
}

extension TasksTableDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard lists.count > 1 else { return nil }
        
        let label = UILabel()
        
        let list = lists[section]
        label.font = .systemFont(ofSize: 20)
        label.text = list.name
        label.textColor = uiColor(for: list.color)
        
        return label
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
