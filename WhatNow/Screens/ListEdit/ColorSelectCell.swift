//
//  ColorSelectCell.swift
//  WhatNow
//
//  Created by Tyler Edwards on 2/10/22.
//

import UIKit

class ColorSelectCell: UITableViewCell {
    
    var selectedColorIndex: Int = 0
    var didChangeColor: ((TaskList.Color) -> Void)?

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.minimumLineSpacing = 1
            layout.minimumInteritemSpacing = 1
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

extension ColorSelectCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TaskList.Color.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let listColor = TaskList.Color(rawValue: indexPath.item) else {
            fatalError("List Color index out of range")
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as? ColorCell else {
            fatalError("Failed to dequeue ColorCell")
        }
        
        cell.configure(color: uiColor(for: listColor), isSelected: indexPath.item == selectedColorIndex)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let prevIndexPath = IndexPath(item: selectedColorIndex, section: 0)
        selectedColorIndex = indexPath.item
        collectionView.reloadItems(at: [prevIndexPath, indexPath])
        
        let color = TaskList.Color.allCases[indexPath.item]
        didChangeColor?(color)
    }
    
}
