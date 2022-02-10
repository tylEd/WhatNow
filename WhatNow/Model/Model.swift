//
//  Model.swift
//  WhatNow
//
//  Created by Tyler Edwards on 1/7/22.
//

import Foundation
import RealmSwift
//TODO: Shouldn't be here after removing UIColor for List Color
import UIKit

class Model {
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

class TaskList: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var color: Color = .Blue
    @Persisted private(set) var tasks: List<Task> //TODO: private doesn't seem to work here.
    
    func add(task: Task) {
        if let realm = realm {
            try? realm.write {
                tasks.append(task)
            }
        } else {
            tasks.append(task)
        }
    }
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

extension TaskList {
    enum Icon: String, PersistableEnum, CaseIterable {
        case BulletList = "list.bullet"
        case Bookmark = "bookmark"
        case Star = "star.fill"
        case Book = "book"
    }
}

//TODO: Where should this go?
func uiColor(for listColor: TaskList.Color) -> UIColor {
    switch listColor {
    case .Red:
        return .systemRed
    case .Orange:
        return .systemOrange
    case .Yellow:
        return .systemYellow
    case .Green:
        return .systemGreen
    case .Mint:
        return .systemMint
    case .Teal:
        return .systemTeal
    case .Cyan:
        return .systemCyan
    case .Blue:
        return .systemBlue
    case .Indigo:
        return .systemIndigo
    case .Purple:
        return .systemPurple
    case .Pink:
        return .systemPink
    case .Brown:
        return .systemBrown
    case .Gray:
        return .systemGray
    }
}


class Task: Object {
    @Persisted var name: String
    @Persisted var status: Status = .Scheduled
    //@Persisted var subtasks: List<Subtask>
    
    func tickStatus() {
        if let realm = realm {
            try? realm.write {
                status = status.next()
            }
        } else {
            status = status.next()
        }
    }
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
