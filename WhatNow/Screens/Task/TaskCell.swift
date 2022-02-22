//
//  TaskCell.swift
//  WhatNow
//
//  Created by Tyler Edwards on 1/11/22.
//

import UIKit

class TaskCell: UITableViewCell {
    
    static let ID = "TaskCell"
    
    var statusTappedCallback: (() -> Void)?
    
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var title: UILabel!
    
    @IBAction func statusTapped(_ sender: UIButton) {
        statusTappedCallback?()
    }
    
}
