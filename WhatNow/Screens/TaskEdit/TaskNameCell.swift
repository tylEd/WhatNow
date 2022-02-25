//
//  TaskNameCell.swift
//  WhatNow
//
//  Created by Tyler Edwards on 2/24/22.
//

import UIKit

class TaskNameCell: UITableViewCell {
    
    static let ID: String = "TaskNameCell"
    
    @IBOutlet var textField: UITextField!
    
    var textDidChange: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let newName = textField.text {
            textDidChange?(newName)
        }
    }
    
}
