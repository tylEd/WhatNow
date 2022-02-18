//
//  Model.swift
//  WhatNow
//
//  Created by Tyler Edwards on 1/7/22.
//

import Foundation
import RealmSwift

//NOTE: Can be removed
class _Model {
    private(set) var localRealm: Realm!
    var lists: Results<TaskList>!
    
    init() {
        openRealm()
        fetchLists()
    }
    
    func openRealm() {
        do {
            var config = Realm.Configuration(schemaVersion: 1)
            config.deleteRealmIfMigrationNeeded = true //TODO: *
            Realm.Configuration.defaultConfiguration = config
            localRealm = try Realm()
        } catch {
            //TODO: *
            fatalError("Couldn't open Realm")
        }
    }
    
    func fetchLists() {
        lists = localRealm.objects(TaskList.self)
    }
    
    func addList(name: String) {
        do {
            try localRealm.write {
                let newList = TaskList(value: ["name": name])
                localRealm.add(newList)
                fetchLists()
            }
        } catch {
            print("ERROR: Failed to add \(name) list to Realm")
        }
    }
    
    func updateList(id: ObjectId, name: String) {
        do {
            let list = localRealm.object(ofType: TaskList.self, forPrimaryKey: id)
            guard let list = list else { return }
            
            try localRealm.write {
                list.name = name
                fetchLists()
                print("Updated task with id \(id)! name: \(name)")
            }
        } catch {
            print("Error updating task \(id) to Realm: \(error)")
        }
    }
    
    func deleteList(id: ObjectId) {
        do {
            let list = localRealm.object(ofType: TaskList.self, forPrimaryKey: id)
            guard let list = list else { return }
            
            try localRealm.write {
                localRealm.delete(list)
                fetchLists()
                print("Deleted task with id \(id)")
            }
        } catch {
            print("Error deleting task \(id) to Realm: \(error)")
        }
    }
}
