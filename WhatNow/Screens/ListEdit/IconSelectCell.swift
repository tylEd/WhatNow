//
//  IconSelectCell.swift
//  WhatNow
//
//  Created by Tyler Edwards on 2/10/22.
//

import UIKit

class IconSelectCell: UITableViewCell {
    
    var selectedIconIndex: Int = 0
    var didChangeIcon: ((TaskList.Icon) -> Void)?
    
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

extension IconSelectCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TaskList.Icon.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconCell", for: indexPath) as? IconCell else {
            fatalError("Failed to dequeue IconCell")
        }
        
        let icon = TaskList.Icon.allCases[indexPath.item]
        cell.configure(imageSystemName: icon.rawValue, isSelected: indexPath.item == selectedIconIndex)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let prevIndexPath = IndexPath(item: selectedIconIndex, section: 0)
        selectedIconIndex = indexPath.item
        collectionView.reloadItems(at: [prevIndexPath, indexPath])
        
        let icon = TaskList.Icon.allCases[indexPath.item]
        didChangeIcon?(icon)
    }
    
}
