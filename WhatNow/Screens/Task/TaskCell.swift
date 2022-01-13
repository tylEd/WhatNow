//
//  TaskCell.swift
//  WhatNow
//
//  Created by Tyler Edwards on 1/11/22.
//

import UIKit

protocol TaskCellDelegate {
    func didTapToggle()
}

class TaskCell: UITableViewCell {
    
    var delegate: TaskCellDelegate?
    
    @IBOutlet weak var toggle: UIButton!
    @IBOutlet weak var title: UILabel!

    @IBAction func didTapToggle(_ sender: UIButton) {
        delegate?.didTapToggle()
    }
}
