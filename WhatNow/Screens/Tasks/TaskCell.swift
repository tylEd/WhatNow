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
    
    var status: Task.Status = .Scheduled {
        didSet {
            statusButton.setBackgroundImage(status.imageForStatus(), for: .normal)
        }
    }
    
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var title: UILabel!
    
    @IBAction func statusTapped(_ sender: UIButton) {
        statusTappedCallback?()
    }
    
}

extension Task.Status {
    func imageForStatus() -> UIImage? {
        switch self {
        case .Scheduled:
            return UIImage(systemName: "circle.dotted")
        case .InProgress:
            return UIImage(systemName: "circle")
        case .Completed:
            return UIImage(systemName: "circle.fill")
        }
    }
}
