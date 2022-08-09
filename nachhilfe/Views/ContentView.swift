//
//  ContentView.swift
//  nachhilfe
//
//  Created by anh :) on 09.08.22.
//

import SwiftUI
import Realm
import RealmSwift

struct ContentView: View {
    @EnvironmentObject var global: Global
    var body: some View {
        ZStack{
            if global.username == ""{
                LoginView()
            } else {
                if let user = realmApp.currentUser{
                    HomeView()
                        .environment(\.realmConfiguration, user.configuration(partitionValue: user.id))
                        .onAppear{
                            realmEnv = try! Realm(configuration: user.configuration(partitionValue: user.id))
                        }
                } else {
                    Text("Der Inhalt konnte nicht geladen werden")
                        .foregroundColor(.gray)
                }
            }
        }
        .onAppear{
            if let user = realmApp.currentUser{
                global.username = user.id
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
