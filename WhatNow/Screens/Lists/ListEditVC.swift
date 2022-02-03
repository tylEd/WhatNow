//
//  ListFormVC.swift
//  WhatNow
//
//  Created by Tyler Edwards on 1/13/22.
//

import UIKit

protocol ListEditVCDelegate {
    func didTapDone(list: TaskList)
}

class ListEditVC: UIViewController {
    
    var list = TaskList(value: ["name": ""])
    var delegate: ListEditVCDelegate?
    
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

extension ListEditVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func uiColor(for listColor: TaskList.Color) -> UIColor {
        switch listColor {
        case .Red:
            return .systemRed
        case .Orange:
            return .systemOrange
        case .Yellow:
            return .systemYellow
        case .Green:
            return .systemGreen
        case .Mint:
            return .systemMint
        case .Teal:
            return .systemTeal
        case .Cyan:
            return .systemCyan
        case .Blue:
            return .systemBlue
        case .Indigo:
            return .systemIndigo
        case .Purple:
            return .systemPurple
        case .Pink:
            return .systemPink
        case .Brown:
            return .systemBrown
        case .Gray:
            return .systemGray
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TaskList.Color.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let listColor = TaskList.Color(rawValue: indexPath.row)! //TODO: !
        let cellID = listColor == list.color ? "SelectedColorCell" : "ColorCell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        cell.contentView.backgroundColor = uiColor(for: listColor)
        cell.contentView.layer.cornerRadius = cell.contentView.bounds.height / 2
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let prevIndexPath = IndexPath(item: list.color.rawValue,
                                      section: 0)

        list.color = TaskList.Color(rawValue: indexPath.item)! //TODO: !

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


extension ListEditVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TimeBlockCell", for: indexPath) as? TimeBlockCell
        else { fatalError("Couldn't dequeue TimeBlockCell") }
        
        return cell
    }
    
    
}
