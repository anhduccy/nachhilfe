//
//  StudentView.swift
//  nachhilfe
//
//  Created by anh :) on 09.08.22.
//

import SwiftUI

struct StudentView: View {
    @Binding var isPresented: Bool
    
    @StateObject var model: StudentLayer = StudentLayer()
    
    var body: some View {
        ZStack{
            VStack(spacing: 20){
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 100).foregroundColor(.teal).opacity(0.2)
                            .frame(width: 30)
                        Image(systemName: "person.text.rectangle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15)
                    }
                    VStack(spacing: 0){
                        TextField("Vorname", text: $model.surname)
                        TextField("Nachname", text: $model.name)
                    }
                    .textFieldStyle(.plain)
                    .font(.title2.bold())
                }
                
                HStack{
                    Icon(systemName: "graduationcap.fill")
                    TextField("Klasse", text: $model.schoolClass)
                        .textFieldStyle(.plain)
                        .font(.title2.bold())
                }
                
                HStack{
                    Icon(systemName: "banknote")
                    TextField("Bezahlung", value: $model.payment, format: .number)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.plain)
                    Text("€")
                }
                .font(.title2.bold())

                HStack{
                    Button("Abbrechen"){
                        isPresented.toggle()
                    }.foregroundColor(.gray)
                    Spacer()
                    Button("Fertig"){
                        //Save function
                        isPresented.toggle()
                    }.bold()
                }
            }
            .foregroundColor(.teal)
        }.padding()
            .frame(width: 300)
    }
}
