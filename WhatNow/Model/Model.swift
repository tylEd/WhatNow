//
//  Model.swift
//  WhatNow
//
//  Created by Tyler Edwards on 1/7/22.
//

import Foundation
import UIKit
import CoreLocation

class Model {
    
    var lists: [List] = []
    
    func loadTestDate() {
        self.lists = [
            List(name: "A", color: .blue),
            List(name: "B", color: .green),
            List(name: "C", color: .yellow),
        ]
        
        for list in self.lists {
            for i in 0..<Int.random(in: 3...6) {
                let task = Task(name: "\(i)")
                task.status = .init(rawValue: i % 3) ?? .Scheduled
                list.tasks.append(task)
            }
        }
    }
    
}

class List {
    
    var name: String
    var color: UIColor
    var tasks: [Task]
    
    init(name: String, color: UIColor) {
        self.name = name
        self.color = color
        self.tasks = []
    }
    
}

class Task {
    
    enum Status: Int, CaseIterable {
        case Scheduled
        case InProgress
        case Completed
        
        mutating func next() {
            let nextStatus = Status(rawValue: self.rawValue + 1) ?? .Scheduled
            self = nextStatus
        }
    }
    
    var name: String
    var status: Status
    var subtasks: [Subtask]
    
    init(name: String) {
        self.name = name
        self.status = .Scheduled
        self.subtasks = []
    }
    
}

class Subtask {
    var name: String
    var isCompleted: Bool = false
    
    init (name: String) {
        self.name = name
    }
}

class Schedule {
    var timeBlocks: [TimeBlock]
    
    init() {
        self.timeBlocks = [
            TimeBlock(name: "Work", days: [1, 2, 3, 4, 5]),
            TimeBlock(name: "Sunday Fun Day", days: [1])
        ]
    }
    
}

class TimeBlock {
    var listIDs: [UUID] = []
    var name: String
    var days: Set<Int> = []
    var startTime: DateComponents = .init(hour: 8, minute: 0)
    var endTime: DateComponents = .init(hour: 12 + 4, minute: 0)
    
    init(name: String, days: Set<Int>? = nil) {
        self.name = name
        if let days = days {
            self.days = days
        }
    }
    
    func testBlock() -> Bool{
        guard let startHour = startTime.hour,
              let startMinute = startTime.minute,
              let endHour = endTime.hour,
              let endMinute = endTime.minute
        else {
            return false
        }
        
        let cal = Locale.current.calendar
        let now = Date()
        
        let weekday = cal.component(.weekday, from: now)
        if days.contains(weekday),
           let start = cal.date(bySettingHour: startHour, minute: startMinute, second: 0, of: now),
           let end = cal.date(bySettingHour: endHour, minute: endMinute, second: 0, of: now),
           start < now && now < end
        {
            return true
        }
        
        return false
    }
    
    var timeRangeText: String {
        guard let startHour = startTime.hour,
              let startMinute = startTime.minute,
              let endHour = endTime.hour,
              let endMinute = endTime.minute
        else {
            return "Add a time"
        }
        
        return "\(startHour):\(startMinute) - \(endHour):\(endMinute)"
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


