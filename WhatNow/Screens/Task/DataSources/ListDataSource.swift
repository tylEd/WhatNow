//
//  ListDataSource.swift
//  WhatNow
//
//  Created by Tyler Edwards on 2/22/22.
//

import Foundation
import RealmSwift

class ListDataSource: TasksTableDataSource {
    
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
    
    private var lists: [TaskList]
    private var notificationTokens: [NotificationToken]
    var changeDelegate: TasksTableDataSourceChangeDelegate? {
        didSet {
            guard changeDelegate != nil else { return }
            setupNotifications()
        }
    }
    
    init(lists: [TaskList]) {
        self.lists = lists
        self.notificationTokens = []
    }
    
    deinit {
        for token in notificationTokens {
            token.invalidate()
        }
    }
    
    func setupNotifications() {
        self.notificationTokens = []
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
            
            self.notificationTokens.append(notificationToken)
        }
    }
    
    func remove(at indexPath: IndexPath) {
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
