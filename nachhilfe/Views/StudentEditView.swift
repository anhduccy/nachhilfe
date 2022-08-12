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
            _model = StateObject(wrappedValue: StudentModel())
            self.student = Student()
        } else {
            _model = StateObject(wrappedValue: StudentModel().toLayer(student: student!))
            self.student = student!
        }
    }
    
    let type: EditViewTypes
    @ObservedRealmObject var student: Student
    @Binding var isPresented: Bool
    @ObservedResults(Student.self) var students
    @StateObject var model: StudentModel
    
    var body: some View {
        ZStack{
            VStack(spacing: 20){
                HStack(spacing: 10){
                    ZStack{
                        RoundedRectangle(cornerRadius: 100).foregroundColor(.teal).opacity(0.2)
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
                    Icon(systemName: "graduationcap.fill")
                    TextField("Klasse", text: $model.schoolClass)
                        .textFieldStyle(.plain)
                        .font(.title2.bold())
                }
                
                HStack(spacing: 10){
                    Icon(systemName: "banknote")
                    TextField("Bezahlung", value: $model.payment, format: .number)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.plain)
                    Text("€")
                }
                .font(.title2.bold())
                Spacer()
                HStack{
                    Button("Abbrechen"){
                        isPresented.toggle()
                    }.foregroundColor(.gray)
                    Spacer()
                    Button("Fertig"){
                        if type == .add{
                            Student.add(students: $students, model: model)
                        } else {
                            Student.update(student: $student, model: model)
                        }
                        isPresented.toggle()
                    }.bold()
                }
            }
            .foregroundColor(.teal)
        }.padding()
    }
}
