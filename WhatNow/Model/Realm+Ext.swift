//
//  Realm+Ext.swift
//  WhatNow
//
//  Created by Tyler Edwards on 2/22/22.
//

import Foundation
import RealmSwift

extension Realm.Configuration {
    
    static var shared: Realm.Configuration = {
        var config = Realm.Configuration.defaultConfiguration
        config.schemaVersion = 2
        return config
    }()
    
}

extension Realm {
    
    static var shared: Realm = {
        do {
            return try Realm(configuration: Realm.Configuration.shared)
        } catch {
            fatalError("Couldn't create shared Realm")
        }
    }()
    
}
