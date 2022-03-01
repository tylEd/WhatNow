//
//  TaskList.swift
//  WhatNow
//
//  Created by Tyler Edwards on 2/17/22.
//

import UIKit
import RealmSwift

class TaskList: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var color: Color = .Red
    @Persisted var icon: Icon = .BulletList
    @Persisted var tasks: List<Task>
    
    func add(task: Task) {
        conditionalWrite {
            tasks.append(task)
        }
    }
    
    func set(color: Color) {
        conditionalWrite {
            self.color = color
        }
    }
    
    func set(icon: Icon) {
        conditionalWrite {
            self.icon = icon
        }
    }
    
    private func conditionalWrite(_ action: () -> Void) {
        if let realm = realm {
            do {
                try realm.write {
                    action()
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            action()
        }
        
    }
}

extension TaskList {
    enum Color: Int, PersistableEnum, CaseIterable {
        case Red
        case Orange
        case Yellow
        case Green
        case Blue
        case Indigo
        case Purple
        case Pink
        case Brown
        case Mint
        case Gray
        case Teal
        case Cyan
        
        var uiColor: UIColor {
            switch self {
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
    }
}

extension TaskList {
    enum Icon: String, PersistableEnum, CaseIterable {
        case BulletList = "list.bullet"
        case Bookmark = "bookmark.fill"
        case Star = "star.fill"
        case Book = "book.fill"
    }
}
