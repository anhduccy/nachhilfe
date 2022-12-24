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
	@Environment(\.colorScheme) var appearance
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
		ZStack{
			VStack(spacing: 10){
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
				HStack{
					ForEach(Student.Colors.allCases, id: \.self){ color in
						Button(action: {
							model.color = color
						}, label: {
							Circle().fill(color.color)
						})
					}
				}.frame(maxHeight: 30)
				
				ScrollView(.vertical, showsIndicators: false){
					HStack(spacing: 10){
						ZStack{
							RoundedRectangle(cornerRadius: 100).foregroundColor(model.color.color).opacity(0.2)
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
						Icon(systemName: "graduationcap.fill", color: model.color.color)
						TextField("Klasse", text: $model.schoolClass)
							.textFieldStyle(.plain)
							.font(.title2.bold())
					}
					
					HStack(spacing: 10){
						Icon(systemName: "banknote", color: model.color.color)
						TextField("Bezahlung", value: $model.payment, format: .currency(code: "EUR"))
							.keyboardType(.decimalPad)
							.textFieldStyle(.plain)
					}
					.font(.title2.bold())
					
					Spacer().ignoresSafeArea(.keyboard)
				}
				
				HStack{
					Button("Abbrechen"){
						isPresented.toggle()
					}
					Spacer()
					if type == .edit{
						Button(action: {
							withAnimation{
								isPresented.toggle()
								Student.delete(student: student)
							}
						}, label: {
							Image(systemName: "trash")
								.foregroundColor(model.color.color)
						})
					}
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
		.foregroundColor(model.color.color)
		.frame(width: 400, height: 320)
	}
}
