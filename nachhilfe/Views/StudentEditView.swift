//
//  StudentEditView.swift
//  nachhilfe
//
//  Created by anh :) on 09.08.22.
//

import SwiftUI
import Realm
import RealmSwift

struct StudentEditView: View {
    init(type: EditViewTypes, student: Student?, isPresented: Binding<Bool>){
        self.type = type
        _isPresented = isPresented
        
        if type == .add{
            self.model = StudentModel()
            self.student = Student()
        } else {
            self.model = StudentModel().toLayer(student: student!)
            self.student = student!
        }
    }
    
    let type: EditViewTypes
    @ObservedRealmObject var student: Student
    @Binding var isPresented: Bool
    @ObservedResults(Student.self) var students
    @ObservedObject var model: StudentModel
        
    var body: some View {
        HStack(alignment: .top){
            ZStack{
                VStack(spacing: 20){
                    HStack(alignment: .top){
                        if type == .add{
                            Text("Neue/r Schüler/in").font(.title.weight(.bold))
                        } else if type == .edit{
                            Text("Dein/e Schüler/in").font(.title.weight(.bold))
                        }
                        Spacer()
                        Button(action: {
                            withAnimation{
                                isPresented.toggle()
                            }
                        }, label: {
                            Image(systemName: "xmark")
                        })
                    }
                    HStack(spacing: 10){
                        ZStack{
                            RoundedRectangle(cornerRadius: 100).foregroundColor(.white).opacity(0.2)
                                .frame(width: 30, height: 70)
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
                    
                    HStack(spacing: 10){
                        Icon(systemName: "graduationcap.fill", color: .white)
                        TextField("Klasse", text: $model.schoolClass)
                            .textFieldStyle(.plain)
                            .font(.title2.bold())
                    }
                    
                    HStack(spacing: 10){
                        Icon(systemName: "banknote", color: .white)
                        TextField("Bezahlung", value: $model.payment, format: .number)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.plain)
                        Text("€")
                    }
                    .font(.title2.bold())
                    
                    Spacer().ignoresSafeArea(.keyboard)

                    HStack{
                        Spacer()
                        Button("Speichern"){
                            if type == .add{
                                Student.add(students: $students, model: model)
                            } else {
                                Student.update(student: $student, model: model)
                            }
                            withAnimation{
                                isPresented.toggle()
                            }
                        }.bold()
                    }
                }
                .padding()
            }
            .background(model.color.color)
            .cornerRadius(20)
            .foregroundColor(.white)
            .frame(width: 350)
            .shadow(radius: 5)
            
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(model.color.color)
                    .opacity(0.2)
                VStack{
                    ForEach(Student.Colors.allCases, id: \.self){ color in
                        Button(action: {
                            model.color = color
                        }, label: {
                            Circle().fill(color.color)
                        })
                    }
                }.padding(.top).padding(.bottom)
            }.frame(width: 30)
            .shadow(radius: 5)
        }
        .frame(height: 400)
    }
}
