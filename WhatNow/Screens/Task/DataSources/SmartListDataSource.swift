//
//  SmartListDataSource.swift
//  WhatNow
//
//  Created by Tyler Edwards on 2/18/22.
//

import Foundation
import RealmSwift

class SmartListDataSource: TasksTableDataSource {
    
    var listCount: Int { smartList.results.count }
    func list(at index: Int) -> TaskList {
        return smartList.results[index]
    }
    
    func taskCount(for section: Int) -> Int {
        return smartList.results[section].tasks.count
    }
    
    func task(at indexPath: IndexPath) -> Task {
        return smartList.results[indexPath.section].tasks[indexPath.row]
    }
    
    private var smartList: SmartList
    private var notificationTokens: [NotificationToken]
    var changeDelegate: TasksTableDataSourceChangeDelegate? {
        didSet {
            guard changeDelegate != nil else { return }
            setupNotifications()
        }
    }
    
    init(smartList: SmartList) {
        self.smartList = smartList
        self.notificationTokens = []
    }
    
    deinit {
        for token in notificationTokens {
            token.invalidate()
        }
    }
    
    func setupNotifications() {
        self.notificationTokens = []
        for listIndex in 0 ..< smartList.results.count {
            let list = smartList.results[listIndex]
            
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
