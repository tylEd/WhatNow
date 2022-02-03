//
//  Model.swift
//  WhatNow
//
//  Created by Tyler Edwards on 1/7/22.
//

import Foundation
import RealmSwift

class Model {
    private(set) var localRealm: Realm!
    var lists: [TaskList] = []
    
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
        let allLists = localRealm.objects(TaskList.self)
        
        lists = []
        allLists.forEach { list in
            lists.append(list)
        }
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
}

class TaskList: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var color: Color = .Blue
    @Persisted var tasks: List<Task>
}

extension TaskList {
    enum Color: Int, PersistableEnum, CaseIterable {
        case Red
        case Orange
        case Yellow
        case Green
        case Mint
        case Teal
        case Cyan
        case Blue
        case Indigo
        case Purple
        case Pink
        case Brown
        case Gray
    }
}

class Task: Object {
    @Persisted var name: String
    @Persisted var status: Status = .Scheduled
    //@Persisted var subtasks: List<Subtask>
}

extension Task {
    enum Status: Int, PersistableEnum {
        case Scheduled
        case InProgress
        case Completed
        
        func next() -> Status {
            let nextStatus = Status(rawValue: self.rawValue + 1) ?? .Scheduled
            return nextStatus
        }
    }
}

class Subtask: Object {
    @Persisted var name: String
    @Persisted var isCompleted: Bool = false
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}


//TODO: Add schedules back in after figuring out Tasks
class TimeBlock {
    struct Time {
        var hour: Int
        var minute: Int
    }
    
    var isActive: Bool = true
    //var name: String
    var days: Set<Int> = []
    var startTime: Time
    var endTime: Time
    
    private static var eightAM = Time(hour: 8, minute: 0)
    private static var fourPM = Time(hour: 4 + 12, minute: 0)
    
    init(days: Set<Int>? = nil, startTime: Time = eightAM, endTime: Time = fourPM) {
        //self.name = name
        self.days = days ?? []
        self.startTime = startTime
        self.endTime = endTime
    }
    
    func testBlock() -> Bool{
        /*
        guard let startHour = startTime.hour,
              let startMinute = startTime.minute,
              let endHour = endTime.hour,
              let endMinute = endTime.minute
        else {
            return false
        }
         */
        
        let cal = Locale.current.calendar
        let now = Date()
        
        let weekday = cal.component(.weekday, from: now)
        if days.contains(weekday),
           let start = cal.date(bySettingHour: startTime.hour, minute: startTime.minute, second: 0, of: now),
           let end = cal.date(bySettingHour: endTime.hour, minute: endTime.minute, second: 0, of: now),
           start < now && now < end
        {
            return true
        }
        
        return false
    }
    
    var timeRangeText: String {
        /*
        guard let startHour = startTime.hour,
              let startMinute = startTime.minute,
              let endHour = endTime.hour,
              let endMinute = endTime.minute
        else {
            return "Add a time"
        }
        */
        
        return "\(startTime.hour):\(startTime.minute) - \(endTime.hour):\(endTime.minute)"
    }
    
    func usefulCalendarProperties() {
        let cal = Locale.current.calendar
        
        print(
            cal.weekdaySymbols,
            cal.shortWeekdaySymbols,
            cal.veryShortWeekdaySymbols,
            
            cal.firstWeekday
        )
        
        fatalError("Not intended to be called. Delete this after figuring out how schedule should work.")
    }
}
