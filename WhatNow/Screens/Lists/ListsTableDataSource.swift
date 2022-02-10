//
//  ListsDataSource.swift
//  WhatNow
//
//  Created by Tyler Edwards on 2/7/22.
//

import UIKit
import RealmSwift

class ListsTableDataSource: NSObject {
    
    private var realm: Realm
    private var notificationToken: NotificationToken!
    
    private(set) var taskLists: Results<TaskList>
    
    //TODO: Should I collapse these into something like the observe changes enum?
    //      Having them indiviually passed like this prevents batch updates on the TableView.
    //      tableView.performBatchUpdates({})
    var didLoad: (() -> Void)?
    var didDelete: (([Int]) -> Void)?
    var didInsert: (([Int]) -> Void)?
    var didChange: (([Int]) -> Void)?
    
    init(config: Realm.Configuration = Realm.Configuration.defaultConfiguration) {
        do {
            //TODO: Configuration should be passed in from some gloabal source. (Dependency injection)
            //TODO: Or should the realm be passed in?
            var config = config
            config.schemaVersion = 2
            self.realm = try Realm(configuration: config)
        } catch {
            fatalError("Couldn't open realm: \(error.localizedDescription)")
        }
        
        self.taskLists = realm.objects(TaskList.self)
        
        super.init()
        
        setupNotifications()
    }
    
    deinit {
        notificationToken.invalidate()
    }
    
    func setupNotifications() {
        notificationToken = taskLists.observe { [unowned self] (changes) in
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                didLoad?()
            case .update(_, let deletions, let insertions, let modifications):
                // It's important to be sure to always update a table in this order:
                // deletions, insertions, then updates. Otherwise, you could be unintentionally
                // updating at the wrong index!
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
    
//MARK: CRUD

extension ListsTableDataSource {
    
    func add(_ newList: TaskList) {
        do {
            try realm.write {
                realm.add(newList)
            }
        } catch {
            print("ERROR: Failed to add \(newList.name) list to Realm")
        }
    }
    
    func updateList(id: ObjectId, name: String) {
        do {
            let list = realm.object(ofType: TaskList.self, forPrimaryKey: id)
            guard let list = list else { return }
            
            try realm.write {
                list.name = name
                print("Updated task with id \(id)! name: \(name)")
            }
        } catch {
            print("Error updating task \(id) to Realm: \(error)")
        }
    }
    
    func delete(_ list: TaskList) {
        do {
            //let list = realm.object(ofType: TaskList.self, forPrimaryKey: id)
            //guard let list = list else { return }
            
            try realm.write {
                realm.delete(list)
            }
        } catch {
            print("Error deleting task \(list.id) to Realm: \(error)")
        }
    }
    
    func list(at index: Int) -> TaskList {
        return taskLists[index]
    }
    
}

//MARK: TableView Data Source

extension ListsTableDataSource: UITableViewDataSource {
    
    //TODO: Could I store ID's on the Cell classes themselves
    static let listTitleCellID = "ListTitleCell"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.listTitleCellID, for: indexPath) as? ListTitleCell
        else {
            fatalError("Couldn't dequeue \(Self.listTitleCellID)")
        }
        
        let list = taskLists[indexPath.row]
        cell.configure(title: list.name,
                       taskCount: list.tasks.count,
                       color: uiColor(for: list.color))
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let list = taskLists[indexPath.row]
        try? realm.write {
            realm.delete(list)
        }
    }
    
}
