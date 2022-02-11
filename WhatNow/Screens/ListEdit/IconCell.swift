//
//  IconCell.swift
//  WhatNow
//
//  Created by Tyler Edwards on 2/10/22.
//

import UIKit

class IconCell: UICollectionViewCell {
    
    @IBOutlet var bgImage: UIImageView!
    @IBOutlet var iconImage: UIImageView!
    
    func configure(imageSystemName: String, isSelected: Bool) {
        iconImage.image = UIImage(systemName: imageSystemName)
        bgImage.tintColor = isSelected ? .systemFill : .clear
    }
    
}
