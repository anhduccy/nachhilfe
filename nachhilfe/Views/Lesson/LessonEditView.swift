//
//  LessonEditView.swift
//  nachhilfe
//
//  Created by anh :) on 14.08.22.
//

import SwiftUI
import Realm
import RealmSwift

class AutoFill{
	static func nextDate(student: Student)->Date{
		let cal = Calendar.current
		var comps = DateComponents()
		let hour = cal.component(.hour, from: student.defaultTime)
		let minutes = cal.component(.minute, from: student.defaultTime)
		comps.weekday = student.weekday.number
		comps.hour = hour
		comps.minute = minutes
		
		var nextWeekday = cal.nextDate(after: Date(), matching: comps, matchingPolicy: .nextTimePreservingSmallerComponents) ?? Date()
		while !student.lessons.filter("date == %@", nextWeekday).isEmpty{
			nextWeekday = nextWeekday.addingTimeInterval(60*60*24*7)
		}
		return nextWeekday
	}
}

struct LessonEditView: View {
	init(type: EditViewTypes, lesson: Lesson?, student: Student? = nil){
		self.type = type
		if type == .add{
			let internModel = LessonModel()
			if student != nil{
				internModel.student = student!
				internModel.date = AutoFill.nextDate(student: student!)
			}
			self.model = internModel
			self.lesson = Lesson()
		} else {
			self.model = LessonModel().toLayer(lesson: lesson!)
			self.lesson = lesson!
		}
		
	}
	
	@Environment(\.colorScheme) var appearance
	@EnvironmentObject var globalVC: GlobalVC
	let type: EditViewTypes
	
	@ObservedResults(Student.self) var students
	@ObservedRealmObject var lesson: Lesson
	@ObservedObject var model: LessonModel
	
	@State var showAlert: Bool = false
	
	var dateFormatter: DateFormatter {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd. MMMM. YYYY"
		dateFormatter.locale = Locale(identifier: "de_DE")
		return dateFormatter
	}
	
	var payment: String{
		let perHour = Double(model.student.payment)
		let perMinute = perHour/60.00
		let payment = perMinute * Double(model.duration)
		return payment.formatted(.currency(code: "EUR"))
	}
		
	var body: some View {
		ZStack{
			VStack{
				HStack{
					Menu(content: {
						ForEach(students, id:\.self){ student in
							Button(action: {
								model.date = AutoFill.nextDate(student: student)
								model.student = student
							}, label: {
								HStack{
									Text(student.surname + " " + student.name)
									if model.student._id == student._id {
										Image(systemName: "checkmark")
											.resizable()
											.scaledToFit()
											.frame(width: 15)
									}
								}
							})
						}
					}, label: {
						VStack(spacing: 0){
							if model.student.surname.isEmpty && model.student.name.isEmpty{
								LeftText("Stunde hinzufügen", font: .title, fontWeight: .bold)
									.foregroundColor(model.student.color.color)
								LeftText("Tippe um Auszuwählen", font: .callout)
									.foregroundColor(.gray)
							} else {
								LeftText("\(model.student.surname) \(model.student.name)", font: .title, fontWeight: .bold)
									.foregroundColor(model.student.color.color)
								if type == .add{
									LeftText("Stunde hinzufügen", font: .callout)
										.foregroundColor(.gray)
								} else {
									LeftText("Stunde am \(dateFormatter.string(from: model.date))", font: .callout)
										.foregroundColor(.gray)
								}
							}
						}
					})
					Spacer()
					VStack(spacing: 3){
						Image(systemName: model.isDone ? "checkmark.circle.fill" : "checkmark.circle")
							.resizable()
							.scaledToFit()
							.frame(width: 25)
							.onTapGesture {
								withAnimation{
									model.isDone.toggle()
								}
							}
							.foregroundColor(model.isDone ? model.student.color.color : .gray)
							.opacity(model.isDone ? 1 : 0.5)
						
						Image(systemName: model.isPayed ? "eurosign.circle.fill" : "eurosign.circle")
							.resizable()
							.scaledToFit()
							.frame(width: 25)
							.onTapGesture {
								withAnimation{
									model.isPayed.toggle()
								}
							}
							.foregroundColor(model.isPayed ? .green : .gray)
							.opacity(model.isPayed ? 1 : 0.5)
					}
				}
				ScrollView(.vertical, showsIndicators: false) {
					VStack(alignment: .leading, spacing: 25){
						VStack(spacing: 10){
							VStack(alignment: .leading){
								LeftText(model.isDone ? "Die Stunde wurde absolviert" : "Die Stunde wurde noch nicht absolviert", font: .callout)
									.foregroundColor(model.isDone ? model.student.color.color : .gray)
								LeftText(model.isPayed ? "Die Stunde wurde bezahlt" : "Die Zahlung ist noch ausstehend", font: .callout)
									.foregroundColor(model.isPayed ? .green : .gray)
							}
						}
						
						VStack(alignment: .leading){
							HStack{
								Icon(systemName: "calendar", color: model.student.color.color)
								DatePicker(selection: $model.date, displayedComponents: [.date, .hourAndMinute], label: {})
									.datePickerStyle(.compact)
							}
							VStack(spacing: 0){
								HStack{
									Icon(systemName: "clock", color: model.student.color.color)
									TextField(value: $model.duration, format: .number, label: {Text("Dauer in Minuten")
									})
									.keyboardType(.decimalPad)
									.textFieldStyle(.roundedBorder)
								}
								HStack{
									Spacer()
									VStack(alignment: .trailing){
										Text("Anfällig: " + payment)
									}.font(.caption)
								}
							}.foregroundColor(.gray)
						}
						VStack{
							VStack(spacing: 5) {
								LeftText("Inhalt der Nachhilfestunde", font: .title3, fontWeight: .bold)
								TextEditor(text: $model.content)
									.border(.gray.opacity(0.5))
									.frame(height: 150)
									.font(.callout)
							}
							
							VStack(spacing: 5) {
								LeftText("Notizen", font: .title3, fontWeight: .bold)
								TextEditor(text: $model.notes)
									.border(.gray.opacity(0.5))
									.frame(height: 150)
									.font(.callout)
							}
						}
						Spacer()
					}
				}
				HStack{
					Button("Abbrechen"){
						withAnimation{
							globalVC.setSelectedLesson(with: nil)
						}
					}.foregroundColor(.gray)
					if type == .edit{
						Spacer()
						Button(action: {
							globalVC.setSelectedLesson(with: nil)
							Lesson.delete(lesson: lesson)
						}, label: {
							Image(systemName: "trash")
								.foregroundColor(.red)
						})
					}
					Spacer()
					
					Button(action: {
						withAnimation{
							switch type {
							case .add:
								if model.student.lessons.filter("date == %@", model.date).isEmpty{
									Lesson.add(model: model)
									globalVC.setSelectedLesson(with: nil)
								} else {showAlert = true}
								
							case .edit:
								if model.student.lessons.filter("date == %@", model.date).isEmpty || !model.student.lessons.filter("date == %@ && _id == %@", model.date, model._id).isEmpty{
									Lesson.update(lesson: $lesson, model: model)
									globalVC.setSelectedLesson(with: nil)
								} else {showAlert = true}
							}
						}
					}, label: {
						Text("Speichern").bold()
							.foregroundColor(model.student.surname == "" && model.student.name == "" ? .gray : model.student.color.color)
					}).alert("Eine Stunde ist bereits für \(model.student.surname) \(model.student.name) zu diesem Zeitpunkt eingetragen", isPresented: $showAlert, actions: {
						Button("OK", role: .cancel){
							showAlert = false
						}
					})
					.disabled(model.student.surname == "" && model.student.name == "")
				}
			}
			.padding()
		}
	}
}

