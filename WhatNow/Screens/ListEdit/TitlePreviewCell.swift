//
//  TitlePreviewCell.swift
//  WhatNow
//
//  Created by Tyler Edwards on 2/10/22.
//

import UIKit

class TitlePreviewCell: UITableViewCell {
    
    var didChangeName: ((String) -> Void)?
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var iconBackgroundImage: UIImageView!
    @IBOutlet var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameField.addTarget(self, action: #selector(nameFieldDidChange(_:)), for: .editingChanged)
    }

    func configure(color: UIColor, imageSystemName: String, name: String = "") {
        iconBackgroundImage.tintColor = color
        iconImage.image = UIImage(systemName: imageSystemName)
        nameField.text = name
        nameField.tintColor = color
        nameField.textColor = color
    }
    
    @objc func nameFieldDidChange(_ textField: UITextField) {
        if let newName = textField.text {
            didChangeName?(newName)
        }
    }
    
}
