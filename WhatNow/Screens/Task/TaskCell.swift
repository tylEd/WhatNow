//
//  TaskCell.swift
//  WhatNow
//
//  Created by Tyler Edwards on 1/11/22.
//

import UIKit

class TaskCell: UITableViewCell {
    
    var didTapToggle: (() -> Void)?
    
    @IBOutlet weak var toggle: UIButton!
    @IBOutlet weak var title: UILabel!

    @IBAction func didTapToggle(_ sender: UIButton) {
        didTapToggle?()
    }
}
