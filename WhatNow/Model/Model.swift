//
//  Model.swift
//  WhatNow
//
//  Created by Tyler Edwards on 1/7/22.
//

import Foundation
import UIKit

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
                task.isCompleted = Bool.random()
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
    
    var name: String
    var isCompleted: Bool
    
    init(name: String) {
        self.name = name
        self.isCompleted = false
    }
    
}
