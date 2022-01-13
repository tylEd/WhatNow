//
//  ListFormVC.swift
//  WhatNow
//
//  Created by Tyler Edwards on 1/13/22.
//

import UIKit

protocol ListFormVCDelegate {
    func didTapDone(list: List)
}

class ListFormVC: UIViewController {
    
    var list = List(name: "", color: .systemRed)
    var delegate: ListFormVCDelegate?
    
    @IBOutlet weak var titleField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
    }
    
    @objc func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc func doneTapped() {
        if let title = titleField.text,
           title != ""
        {
            list.name = title
            delegate?.didTapDone(list: list)
            dismiss(animated: true)
        }
    }
    
}

extension ListFormVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    static let COLORS: [UIColor] = [
        .systemRed,
        .systemOrange,
        .systemYellow,
        .systemGreen,
        .systemBlue,
        .systemPink,
        .systemPurple,
        .systemTeal,
        .systemIndigo,
        .systemBrown,
        .systemMint,
        .systemCyan,
        .systemGray,
    ]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Self.COLORS.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellID = Self.COLORS[indexPath.item] == list.color ? "SelectedColorCell" : "ColorCell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        cell.contentView.backgroundColor = Self.COLORS[indexPath.item]
        cell.contentView.layer.cornerRadius = cell.contentView.bounds.height / 2
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let prevIndexPath = IndexPath(item: Self.COLORS.firstIndex(of: list.color)!,
                                      section: 0)
        
        list.color = Self.COLORS[indexPath.item]
        
        collectionView.reloadItems(at: [prevIndexPath, indexPath])
    }
    
}

//MARK: Static Lists


let SYMBOLS: [String] = [
    "list.bullet",
    "bookmark",
    "star.fill",
    "wallet",
]

