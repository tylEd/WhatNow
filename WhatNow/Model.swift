//
//  Model.swift
//  WhatNow
//
//  Created by Tyler Edwards on 1/7/22.
//

import Foundation
import UIKit

class Model {
    var areas: [Area] = []
}

class Area {
    var name: String
    var color: UIColor
    var tasks = [Task]()
    
    init(name: String, color: UIColor) {
        self.name = name
        self.color = color
    }
    
    //TODO: This is non-trivial
    // Which days of the week and what times during those days.
    // Needs a working list that shows what to work on now based on scheduled events, and a widget that will show those tasks.
    // Needs to be able to be queried for which areas are valid right now. Get Date.now() find the day of the week and time of day, and get back each area that has a time frame matching it.
    //var schedule: [DateRanges / Times and Days]
}

class Task {
    var name: String
    var subtasks = [Task]()
    
    //TODO: *
    // var dueDate: Date?
    
    init(name: String) {
        self.name = name
    }
}
