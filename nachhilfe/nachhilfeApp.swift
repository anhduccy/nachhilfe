//
//  nachhilfeApp.swift
//  nachhilfe
//
//  Created by anh :) on 09.08.22.
//

import SwiftUI
import Realm
import RealmSwift

let realmApp = RealmSwift.App(id: "nachhilfe-qnbvj")
var realmEnv = try! Realm(configuration: .defaultConfiguration)

@main
struct nachhilfeApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear{
                    if let user = realmApp.currentUser{
                        print(user.configuration(partitionValue: user.id).fileURL?.path ?? "Could not find realm database in files")
                    }
                    UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatifaiable")
                }
                .environmentObject(Global())
                .navigationTitle("Nachhilfe")
        }
    }
}
