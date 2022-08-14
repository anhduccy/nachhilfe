//
//  LoginView.swift
//  nachhilfe
//
//  Created by anh :) on 09.08.22.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.colorScheme) var appearance
    @EnvironmentObject var global: Global
    
    @State var email: String = ""
    @State var password: String = ""
    
    @State var showErrorMessage: String = ""
    var body: some View {
        ZStack{
            HStack{
                Spacer()
                Text("Nach")
                    .font(.system(size: 80))
                    .fontWeight(.black)
                    .foregroundColor(.teal)
                Spacer()
                VStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.teal)

                        
                        VStack{
                            TextField("E-Mail", text: $email)
                                .textFieldStyle(.roundedBorder)
                            SecureField("Passwort", text: $password)
                                .textFieldStyle(.roundedBorder)
                        }
                        .padding()
                    }
                    .frame(height: 250)
                    HStack{
                        Spacer()
                        Button("Registrieren"){
                            register()
                        }.foregroundColor(.gray)
                        
                        Button(action: {
                            login()
                        }, label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.teal)
                                Text("Anmelden")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }.frame(width: 120, height: 40)
                        })
                    }
                }.frame(width: 500)
                Spacer()
                Text("hilfe.")
                    .font(.system(size: 80))
                    .fontWeight(.black)
                    .foregroundColor(appearance == .dark ? .white : .black)
                Spacer()
            }
        }
    }
    private func login(){
        Task {
            do {
                let user = try await realmApp.login(credentials: .emailPassword(email: email, password: password))
                global.username = user.id
            } catch{
                showErrorMessage = "\(error.localizedDescription)".capitalized(with: Locale(identifier: "en"))
            }
        }
    }
    private func register(){
        Task {
            do {
                try await realmApp.emailPasswordAuth.registerUser(email: email, password: password)
                login()
            } catch{
                showErrorMessage = "\(error.localizedDescription)".capitalized(with: Locale(identifier: "en"))
            }
        }
    }
}
