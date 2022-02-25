//
//  SmartListDataSource.swift
//  WhatNow
//
//  Created by Tyler Edwards on 2/18/22.
//

import Foundation
import RealmSwift

protocol SmartList {
    var name: String { get }
    var color: TaskList.Color { get }
    var icon: TaskList.Icon { get }
    var totalTasks: Int { get }
}

typealias SmartListDataSource = SmartList & TasksTableDataSource

class SmartLists {
    static let all: [SmartListDataSource] = [AllTasksDataSource(), InProgressDataSource()]
}
