//
//  SettingsView.swift
//  nachhilfe
//
//  Created by anh :) on 13.08.23.
//

import SwiftUI
import UserNotifications


struct SettingsView: View{
    @EnvironmentObject var global: Global
    
    @Binding var isPresented: Bool
    
    @AppStorage("notificationTime") private var notificationTime: Date = Date()
    @State var logout_error: Bool = false
    var body: some View{
        NavigationView{
            Form{
                Section{
                    HStack{
                        Icon(systemName: "bell", color: .teal)
                        DatePicker("Mitteilungszeit", selection: $notificationTime, displayedComponents: [.hourAndMinute])
                    }
                }
                
                Section(footer: Text("User-ID: \(global.username)")){
                    HStack{
                        Icon(systemName: "door.left.hand.open", color: .red)
                        Button("Abmelden", role: .destructive){
                            global.username = ""
                            realmApp.currentUser?.logOut { (error) in
                                logout_error = true
                            }
                        }
                        Spacer()
                        if logout_error{
                            Text("Ein Fehler ist aufgetreten")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Einstellungen")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Schließen"){
                        isPresented.toggle()
                    }
                }
            }
        }
        .onChange(of: notificationTime){ _ in
            NotificationCenter.updateAllNotifications()
        }
    }
}

extension Date: RawRepresentable {
    public var rawValue: String {
        self.timeIntervalSinceReferenceDate.description
    }
    
    public init?(rawValue: String) {
        self = Date(timeIntervalSinceReferenceDate: Double(rawValue) ?? 0.0)
    }
}

