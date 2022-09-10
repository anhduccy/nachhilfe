//
//  LessonEditView.swift
//  nachhilfe
//
//  Created by anh :) on 14.08.22.
//

import SwiftUI
import Realm
import RealmSwift

struct LessonEditView: View {
	init(type: EditViewTypes, lesson: Lesson?, isPresented: Binding<Bool>){
		_isPresented = isPresented
		self.type = type
		if type == .add{
			self.model = LessonModel()
			self.selectedLesson = Lesson()
		} else {
			self.model = LessonModel().toLayer(lesson: lesson!)
			self.selectedLesson = lesson!
		}
		
	}
	
	@Environment(\.colorScheme) var appearance
	@Binding var isPresented: Bool
	let type: EditViewTypes
	
	@ObservedResults(Student.self) var students
	@ObservedRealmObject var selectedLesson: Lesson
	@ObservedObject var model: LessonModel
	
	var dateFormatter: DateFormatter {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd. MMMM. YYYY"
		dateFormatter.locale = Locale(identifier: "de_DE")
		return dateFormatter
	}
		
	var body: some View {
		ZStack{
			VStack{
				HStack{
					Menu(content: {
						ForEach(students, id:\.self){ student in
							Button(action: {
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
							if model.student.surname == "" && model.student.name == ""{
								LeftText("Stunde hinzufügen", font: .title, fontWeight: .bold)
									.foregroundColor(model.student.color.color)
								LeftText("Tippe um Auszuwählen", font: .callout)
									.foregroundColor(.gray)
							} else {
								LeftText("\(model.student.surname) \(model.student.name)", font: .title, fontWeight: .bold)
									.foregroundColor(model.student.color.color)
								LeftText("Stunde vom \(dateFormatter.string(from: model.date))", font: .callout)
									.foregroundColor(.gray)
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
									Text(calculatePayment()).font(.caption)
								}
							}.foregroundColor(.gray)
						}
						Spacer()
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
							isPresented = false
						}
					}.foregroundColor(.gray)
					if type == .edit{
						Spacer()
						Button(action: {
							withAnimation{
								isPresented = false
								Lesson.delete(lesson: selectedLesson)
							}
						}, label: {
							Image(systemName: "trash")
								.foregroundColor(.red)
						})
					}
					Spacer()
					Button("Speichern"){
						withAnimation{
							if type == .add{
								Lesson.add(model: model)
							} else if type == .edit{
								Lesson.update(lesson: $selectedLesson, model: model)
							}
							isPresented = false
						}
					}.bold()
						.disabled(model.student.surname == "" && model.student.name == "")
						.foregroundColor(model.student.surname == "" && model.student.name == "" ? .gray : model.student.color.color)
				}
			}
			.padding(20)
		}
	}
	private func calculatePayment()->String{
		let perHour = Double(model.student.payment)
		let perMinute = perHour/60.00
		let payment = perMinute * Double(model.duration)
		let paymentBonus = payment / 2 + payment
		let paymentRounded = String(format: "%.2f", paymentBonus)
		return paymentRounded + "€"
	}
}

