//
//  ColorCell.swift
//  WhatNow
//
//  Created by Tyler Edwards on 2/10/22.
//

import UIKit

class ColorCell: UICollectionViewCell {
    
    @IBOutlet var circleImage: UIImageView!
    
    func configure(color: UIColor, isSelected: Bool) {
        circleImage.tintColor = color
        circleImage.image = isSelected ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle.fill")
    }
    
}
