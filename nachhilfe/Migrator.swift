//
//  Migrator.swift
//  nachhilfe
//
//  Created by anh :) on 09.08.23.
//

import Foundation
import RealmSwift

class Migrator{
    init(){
        updateSchema()
    }
        
    func updateSchema(){
        let version = 1

        let config = Realm.Configuration(schemaVersion: UInt64(version)){ migration, oldSchemaVersion in
            if oldSchemaVersion < version {
                migration.enumerateObjects(ofType: Student.className()){ _, newObject in
                    newObject!["weekday"] = 0
                }
            }
        }
        Realm.Configuration.defaultConfiguration = config
        let _ = try! Realm()
    }
}
