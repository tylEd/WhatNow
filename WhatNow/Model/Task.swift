//
//  Task.swift
//  WhatNow
//
//  Created by Tyler Edwards on 2/17/22.
//

import Foundation
import RealmSwift

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