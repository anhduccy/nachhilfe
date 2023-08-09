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
	
	@State var showAlert: Bool = false
        
    var body: some View {
		NavigationView{
			Form{
				Section("Farben"){
					HStack{
						Spacer()
						ForEach(Student.Colors.allCases, id: \.self){ color in
							Button(action: {
								model.color = color
							}, label: {
								Circle().fill(color.color)
							}).buttonStyle(.borderless)
						}
						Spacer()
					}.padding(.trailing)
						.frame(height: 30)
				}
				
				Section("Personalien"){
					HStack{
						Icon(systemName: "person.text.rectangle", color: model.color.color)
						TextField("Vorname", text: $model.surname).foregroundColor(model.color.color)
					}
					HStack{
						Icon(systemName: "person.text.rectangle", color: model.color.color)
						TextField("Nachname", text: $model.name).foregroundColor(model.color.color)
					}
					HStack{
						Icon(systemName: "graduationcap", color: model.color.color)
						TextField("Klasse", text: $model.schoolClass).foregroundColor(model.color.color)
					}
				}
				
				Section("Standard-Nachhilfestunde"){
					HStack{
						Icon(systemName: "calendar", color: model.color.color)
						Picker(selection: $model.weekday, label: Text("Standardwochentag")){
							ForEach(Student.Weekdays.allCases, id: \.self){ weekday in
								Text(weekday.name).tag(weekday)
							}
						}.foregroundColor(model.color.color)
					}
					
					HStack{
						Icon(systemName: "clock", color: model.color.color)
						DatePicker("Standarduhrzeit", selection: $model.defaultTime, displayedComponents: [.hourAndMinute])
					}
					
					HStack{
						Icon(systemName: "eurosign", color: model.color.color)
						TextField("Bezahlung", value: $model.payment, format: .currency(code: "EUR"))
							.keyboardType(.decimalPad)
							.foregroundColor(model.color.color)
					}
				}
				
				if type == .edit {
					Section{
						HStack{
							Icon(systemName: "trash", color: .red)
							Button("Löschen"){
								showAlert.toggle()
							}.alert("Löschen bestätigen", isPresented: $showAlert, actions: {
								Button("Abbrechen", role: .cancel){
									showAlert.toggle()
								}
								Button("Löschen", role: .destructive){
									isPresented.toggle()
									Student.delete(student: student)
								}
							}, message: {Text("Möchtest du wirklich \(model.surname) \(model.name) löschen? Alle Nachhilfestunden und Klausuren werden gelöscht")})
							.foregroundColor(.red)
						}
					}
				}
				
				Section{
					HStack{
						Icon(systemName: "door.left.hand.open", color: .gray)
						Button("Abbrechen"){
							isPresented.toggle()
						}.foregroundColor(.gray)
					}
					
					if model.surname != "" && model.name != "" {
						HStack{
							Icon(systemName: "square.and.arrow.down", color: model.color.color)
							Button("Speichern"){
								if type == .add{
									Student.add(students: $students, model: model)
								} else {
									Student.update(student: $student, model: model)
								}
								isPresented.toggle()
							}.foregroundColor(model.color.color)
						}
					}
				}
			}.navigationTitle(type == .add ? Text("Schüler hinzufügen") : Text("\(model.surname) \(model.name)"))
		}
	}
}
