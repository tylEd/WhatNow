//
//  AllTasksDataSource.swift
//  WhatNow
//
//  Created by Tyler Edwards on 2/23/22.
//

import Foundation
import RealmSwift

class AllTasksDataSource: TasksTableDataSource, SmartList {
    
    private var lists: Results<TaskList>
    private var taskTokens: [NotificationToken] = []
    
    init() {
        self.lists = Realm.shared.objects(TaskList.self)
        setupTaskNotifications()
    }
    
    deinit {
        for token in taskTokens {
            token.invalidate()
        }
    }
    
    func setupTaskNotifications() {
        self.taskTokens = []
        for listIndex in 0 ..< lists.count {
            let list = lists[listIndex]
            
            let notificationToken = list.tasks.observe(keyPaths: ["name"]) { [unowned self] changes in
                switch changes {
                case .initial:
                    changeDelegate?.initial()
                case .update(_, let deletions, let insertions, let modifications):
                    changeDelegate?.update(section: listIndex, deletions: deletions, insertions: insertions, modifications: modifications)
                case .error(let error):
                    fatalError("\(error)")
                }
            }
            
            self.taskTokens.append(notificationToken)
        }
    }
    
    //MARK: SmartList
    
    var name: String { "All" }
    var color: TaskList.Color { .Blue }
    var icon: TaskList.Icon { .BulletList }
    var totalTasks: Int {
        var total = 0
        for list in lists {
            total += list.tasks.count
        }
        return total
    }
    
    //MARK: TasksTableDataSource
    
    weak var changeDelegate: TasksTableDataSourceChangeDelegate?
    
    var listCount: Int { lists.count }
    
    func list(at index: Int) -> TaskList {
        return lists[index]
    }
    
    func taskCount(for section: Int) -> Int {
        return lists[section].tasks.count
    }
    
    func task(at indexPath: IndexPath) -> Task {
        return lists[indexPath.section].tasks[indexPath.row]
    }
    
    func remove(at indexPath: IndexPath) {
        let task = lists[indexPath.section].tasks[indexPath.row]
        if let realm = task.realm {
            try? realm.write {
                realm.delete(task)
            }
        }
    }
    
}
