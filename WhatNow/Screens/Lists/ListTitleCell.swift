//
//  ListTitleCell.swift
//  WhatNow
//
//  Created by Tyler Edwards on 2/9/22.
//

import UIKit

class ListTitleCell: UITableViewCell {
    
    static let reuseID = "ListTitleCell"
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var taskCountLabel: UILabel!
    @IBOutlet private var iconBGImage: UIImageView!
    @IBOutlet private var iconImage: UIImageView!
    
    func configure(title: String,
                   taskCount: Int,
                   color: UIColor = .systemBlue,
                   iconSystemName: String = "list.bullet")
    {
        titleLabel.text = title
        taskCountLabel.text = "\(taskCount)"
        iconBGImage.tintColor = color
        iconImage.image = UIImage(systemName: iconSystemName)
    }
    
}
