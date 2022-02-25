//
//  TasksTableDataSource.swift
//  WhatNow
//
//  Created by Tyler Edwards on 2/11/22.
//

import Foundation
import RealmSwift

protocol TasksTableDataSourceChangeDelegate: AnyObject {
    func initial()
    func update(section: Int, deletions: [Int], insertions: [Int], modifications: [Int])
}

protocol TasksTableDataSource {
    //NOTE: This whould be a weak reference to prevent holding onto any VC that responds to it.
    var changeDelegate: TasksTableDataSourceChangeDelegate? { get set }
    
    var listCount: Int { get }
    func list(at index: Int) -> TaskList
    
    func taskCount(for section: Int) -> Int
    func task(at indexPath: IndexPath) -> Task
    
    func remove(at indexPath: IndexPath)
}
