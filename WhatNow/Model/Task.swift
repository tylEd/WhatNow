//
//  Task.swift
//  WhatNow
//
//  Created by Tyler Edwards on 2/17/22.
//

import Foundation
import RealmSwift

class Task: EmbeddedObject {
    @Persisted(originProperty: "tasks") var list: LinkingObjects<TaskList>
    @Persisted var name: String
    @Persisted var status: Status = .Scheduled
    
    convenience init(name: String, status: Status = .Scheduled) {
        self.init()
        self.name = name
        self.status = status
    }
    
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
