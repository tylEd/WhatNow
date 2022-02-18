//
//  TasksTableSmartDataSource.swift
//  WhatNow
//
//  Created by Tyler Edwards on 2/18/22.
//

import UIKit
import RealmSwift

class TasksTableSmartDataSource: NSObject {
    
    private var smartList: SmartList
    private var notificationTokens: [NotificationToken]
    
    //TODO: Should I collapse these into something like the observe changes enum?
    //      Having them indiviually passed like this prevents batch updates on the TableView.
    //      tableView.performBatchUpdates({})
    typealias Update = (Int, [Int]) -> Void
    var didLoad: (() -> Void)?
    var didDelete: Update?
    var didInsert: Update?
    var didChange: Update?
    
    init(smartList: SmartList) {
        self.smartList = smartList
        self.notificationTokens = []
        
        super.init()
        
//        setupNotifications()
    }
    
    deinit {
        for token in notificationTokens {
            token.invalidate()
        }
    }
    
//    func setupNotifications() {
//        self.notificationTokens = []
//        for list in lists {
//            //TODO: I would prefer for this to just get changes to the List, but now sure how currently.
//            //      Might be as simple as ignoring modifications. Need to check that moves don't trigger that before I remove it.
//            let notificationToken = list.tasks.observe(keyPaths: ["name"]) { [unowned self] changes in
//                switch changes {
//                case .initial:
//                    didLoad?()
//                case .update(_, let deletions, let insertions, let modifications):
//                    //TODO: Need to pass the list / section index too.
//                    if let section = lists.firstIndex(of: list) {
//                        didDelete?(section, deletions)
//                        didInsert?(section, insertions)
//                        didChange?(section, modifications)
//                    }
//                case .error(let error):
//                    // An error occurred while opening the Realm file on the background worker thread
//                    fatalError("\(error)")
//                }
//            }
//
//            self.notificationTokens.append(notificationToken)
//        }
//    }
    
}
    
//MARK: TableView Data Source

extension TasksTableSmartDataSource: UITableViewDataSource {
    
    //TODO: Could I store ID's on the Cell classes themselves
    static let taskCellID = "TaskCell"
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return smartList.results.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: *
        return smartList.results[section].tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.taskCellID, for: indexPath) as? TaskCell
        else {
            fatalError("Couldn't dequeue \(Self.taskCellID)")
        }
        
        let list = smartList.results[indexPath.section]
        let task = list.tasks[indexPath.row]
        cell.statusButton.setBackgroundImage(task.status.imageForStatus(), for: .normal)
        //TODO: Add uiColor as a property on TaskList.Color
        cell.statusButton.tintColor = list.color.uiColor
        cell.title.text = task.name
        cell.statusTappedCallback = {
            task.tickStatus()
            cell.statusButton.setBackgroundImage(task.status.imageForStatus(), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let list = smartList.results[indexPath.section]
        if let realm = list.realm {
            try? realm.write {
                list.tasks.remove(at: indexPath.row)
            }
        } else {
            list.tasks.remove(at: indexPath.row)
        }
    }
    
}

extension TasksTableSmartDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard smartList.results.count > 1 else { return nil }
        
        let label = UILabel()
        
        let list = smartList.results[section]
        label.font = .systemFont(ofSize: 20)
        label.text = list.name
        label.textColor = list.color.uiColor
        
        return label
    }
    
}
