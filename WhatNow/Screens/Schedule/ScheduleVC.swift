//
//  ScheduleVC.swift
//  WhatNow
//
//  Created by Tyler Edwards on 1/18/22.
//

import UIKit

class ScheduleVC: UITableViewController {
    
    var schedule = Schedule()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension ScheduleVC {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule.timeBlocks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        
        let timeBlock = schedule.timeBlocks[indexPath.row]
        cell.textLabel?.text = timeBlock.name
        cell.detailTextLabel?.text = timeBlock.timeRangeText
        
        return cell
    }
    
}
