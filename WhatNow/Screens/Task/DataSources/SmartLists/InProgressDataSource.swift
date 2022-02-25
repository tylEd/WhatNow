//
//  InProgressDataSource.swift
//  WhatNow
//
//  Created by Tyler Edwards on 2/22/22.
//

import Foundation
import RealmSwift
import UIKit

class InProgressDataSource: TasksTableDataSource, SmartList {
    
    private var lists: Results<TaskList>
    private var listsToken: NotificationToken!
    
    private var taskResults: [Results<Task>] = []
    private var taskTokens: [NotificationToken] = []
    
    init() {
        self.lists = Realm.shared.objects(TaskList.self).where {
            $0.tasks.status == .InProgress
        }
        
        setupListNotifications()
    }
    
    func setupListNotifications() {
        listsToken = lists.observe { [unowned self] changes in
            switch changes {
            case .initial:
                fallthrough
            case .update(_, _, _, _):
                //TODO: Respond to the deletions and insertions so the table doesn't have to do a full reload here. ***************************
                queryTasks()
                changeDelegate?.initial()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    func queryTasks() {
        //TODO: Is it possible to use a live query for tasks here instead of an array? *******************************************************
        self.taskResults = []
        
        for list in self.lists {
            let taskResult = list.tasks.where {
                $0.status == .InProgress
            }
            self.taskResults.append(taskResult)
        }
        
        setupTaskNotifications()
    }
    
    func setupTaskNotifications() {
        self.taskTokens = []
        for taskResultIndex in 0 ..< taskResults.count {
            let taskResult = taskResults[taskResultIndex]
            
            let notificationToken = taskResult.observe(keyPaths: ["name"]) { [unowned self] changes in
                switch changes {
                case .initial:
                    changeDelegate?.initial()
                case .update(_, let deletions, let insertions, let modifications):
                    changeDelegate?.update(section: taskResultIndex, deletions: deletions, insertions: insertions, modifications: modifications)
                case .error(let error):
                    fatalError("\(error)")
                }
            }
            
            self.taskTokens.append(notificationToken)
        }
    }
    
    //MARK: SmartList
    
    var name: String { "In Progress" }
    var color: TaskList.Color { .Orange }
    var icon: TaskList.Icon { .Star }
    var totalTasks: Int {
        var total = 0
        for taskResult in taskResults {
            total += taskResult.count
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
        return taskResults[section].count
    }
    
    func task(at indexPath: IndexPath) -> Task {
        return taskResults[indexPath.section][indexPath.row]
    }
    
    func remove(at indexPath: IndexPath) {
        let task = taskResults[indexPath.section][indexPath.row]
        if let realm = task.realm {
            try? realm.write {
                realm.delete(task)
            }
        }
    }
    
}
