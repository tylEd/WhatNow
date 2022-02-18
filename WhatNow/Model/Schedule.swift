//
//  Schedule.swift
//  WhatNow
//
//  Created by Tyler Edwards on 2/17/22.
//

import Foundation

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
    
    func testBlock() -> Bool {
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
