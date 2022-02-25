//
//  TaskListPickerCell.swift
//  WhatNow
//
//  Created by Tyler Edwards on 2/24/22.
//

import UIKit

class TaskListPickerCell: UITableViewCell {
    
    static let ID: String = "TaskListPickerCell"

    @IBOutlet var picker: UIPickerView!
    
    var lists: [TaskList] = []
    var didChangeSelection: ((TaskList) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        picker.dataSource = self
        picker.delegate = self
    }
    
    func configure(with lists: [TaskList]) {
        self.lists = lists
        picker.reloadAllComponents()
    }

}

extension TaskListPickerCell: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return lists[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        didChangeSelection?(lists[row])
    }
    
}

extension TaskListPickerCell: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lists.count
    }
    
}
