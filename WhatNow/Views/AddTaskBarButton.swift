//
//  AddTaskBarButton.swift
//  WhatNow
//
//  Created by Tyler Edwards on 3/1/22.
//

import UIKit

class NewTaskButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
        var addTaskConfig = UIButton.Configuration.plain()
        addTaskConfig.image = UIImage(systemName: "plus.circle.fill")
        addTaskConfig.imagePadding = 8
        addTaskConfig.contentInsets = .init(top: 5, leading: 0, bottom: 5, trailing: 5)
        
        configuration = addTaskConfig
        setTitle("New Task", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
