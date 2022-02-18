//
//  SmartList.swift
//  WhatNow
//
//  Created by Tyler Edwards on 2/17/22.
//

import UIKit
import RealmSwift

//MARK: Smart Lists

class SmartList {
    
    var realm: Realm
    var results: Results<TaskList>
    
    var name = ""
    var color = TaskList.Color.Blue
    var icon = TaskList.Icon.BulletList
    
    var taskCount: Int {
        var total = 0
        for list in results {
            total += list.tasks.count
        }
        
        return total
    }
    
    private init() {
        //TODO: How to pass the Realm info / db around?
        var config = Realm.Configuration.defaultConfiguration
        config.schemaVersion = 2
        config.deleteRealmIfMigrationNeeded = true //TODO: *
        
        self.realm = try! Realm(configuration: config)
        self.results = realm.objects(TaskList.self)
    }
    
    static var allTasks: SmartList = {
        let all = SmartList()
        
        all.results = all.realm.objects(TaskList.self)
        
        all.name = "All"
        all.color = .Blue
        all.icon = .BulletList
        
        return all
    }()
    
    static var whatNowTasks: SmartList = {
        let whatNow = SmartList()
        
        whatNow.results = whatNow.realm.objects(TaskList.self)
        
        whatNow.name = "WhatNow"
        whatNow.color = .Yellow
        whatNow.icon = .BulletList
        
        return whatNow
    }()
    
    static var all = [allTasks, whatNowTasks]
    
}
