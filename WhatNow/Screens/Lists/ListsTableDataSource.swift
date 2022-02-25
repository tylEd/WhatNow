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
    
    //TODO: Use the change delegate. Make it a generic RealmCollectionChangeDelegate or something like that. 
    var didLoad: (() -> Void)?
    var didDelete: (([Int]) -> Void)?
    var didInsert: (([Int]) -> Void)?
    var didChange: (([Int]) -> Void)?
    
    init(config: Realm.Configuration = Realm.Configuration.defaultConfiguration) {
        self.realm = Realm.shared
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
                didLoad?()
            case .update(_, let deletions, let insertions, let modifications):
                didDelete?(deletions)
                didInsert?(insertions)
                didChange?(modifications)
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
}
    
//MARK: CRUD

extension ListsTableDataSource {
    
    func addOrUpdate(_ list: TaskList) {
        do {
            let listToUpdate = realm.object(ofType: TaskList.self, forPrimaryKey: list.id)
            if let listToUpdate = listToUpdate {
                let updatedValues: [String : Any] = ["name": list.name,
                                     "color": list.color,
                                     "icon": list.icon]
                try realm.write {
                    listToUpdate.setValuesForKeys(updatedValues)
                }
            } else {
                try realm.write {
                    //NOTE: This doesn't work since TaskList contains EmbededObjects, hence the above update.
                    realm.add(list, update: .modified)
                }
            }
        } catch {
            print("ERROR: Failed to add \(list.name) list to Realm")
        }
    }
    
    func delete(_ list: TaskList) {
        do {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return SmartLists.all.count
        }
        
        return taskLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.listTitleCellID, for: indexPath) as? ListTitleCell
        else {
            fatalError("Couldn't dequeue \(Self.listTitleCellID)")
        }
        
        if indexPath.section == 0 {
            let smartList = SmartLists.all[indexPath.row]
            cell.configure(title: smartList.name,
                           taskCount: smartList.totalTasks,
                           color: smartList.color.uiColor,
                           iconSystemName: smartList.icon.rawValue)
        } else {
            let list: TaskList
            list = taskLists[indexPath.row]
            cell.configure(title: list.name,
                           taskCount: list.tasks.count,
                           color: list.color.uiColor,
                           iconSystemName: list.icon.rawValue)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        guard indexPath.section != 0 else { return }
        
        let list = taskLists[indexPath.row]
        try? realm.write {
            realm.delete(list)
        }
    }
    
}
