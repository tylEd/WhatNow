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
            list.tasks = [
                Task(name: "1"),
                Task(name: "2"),
                Task(name: "3"),
                Task(name: "4"),
            ]
            
            let randIndex = Int.random(in: 0 ..< list.tasks.count)
            list.tasks[randIndex].isCompleted.toggle()
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
