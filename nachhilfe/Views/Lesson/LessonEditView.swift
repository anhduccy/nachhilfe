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
		
		let students = realmEnv.objects(Student.self)
		if students.first != nil {
			_selectedStudent = State(initialValue: students.first!)
		} else {
			_selectedStudent = State(initialValue: Student()) //TO-DO: ERROR MELDUNG
		}
		print(_selectedStudent)
	}
	
	@Environment(\.colorScheme) var appearance
	@Binding var isPresented: Bool
	let type: EditViewTypes
	@ObservedRealmObject var selectedLesson: Lesson
	@ObservedObject var model: LessonModel
	
	@ObservedResults(Student.self) var students
	@State var selectedStudent: Student
	
	var body: some View {
		GeometryReader{ geo in
			ZStack{
				VStack{
					ScrollView(.vertical, showsIndicators: false) {
						VStack(alignment: .leading, spacing: 25){
							HStack{
								Menu(content: {
									ForEach(students, id:\.self){ student in
										Button(action: {
											selectedStudent = student
										}, label: {
											HStack{
												Text(student.surname + " " + student.name)
												if selectedStudent == student {
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
										LeftText("\(selectedStudent.surname) \(selectedStudent.name)", font: .title, fontWeight: .bold)
											.foregroundColor(.teal)
										LeftText(type == .add ? "Neue Stunde hinzufügen" : "Stunde vom /{Datum}", font: .callout)
											.foregroundColor(.gray)
									}
								})
								Spacer()
								VStack(spacing: 3){
									Icon(systemName: model.isDone ? "checkmark.circle.fill" : "checkmark.circle", color: .blue, isActivated: model.isDone)
										.onTapGesture {
											withAnimation{
												model.isDone.toggle()
											}
										}
									Icon(systemName: model.isPayed ? "eurosign.circle.fill" : "eurosign.circle", color: .green, isActivated: model.isPayed)
										.onTapGesture {
											withAnimation{
												model.isPayed.toggle()
											}
										}
								}
							}
							
							VStack(alignment: .leading){
								HStack{
									Icon(systemName: "calendar")
									DatePicker(selection: $model.date, displayedComponents: [.date, .hourAndMinute], label: {})
										.datePickerStyle(.compact)
								}
								VStack(spacing: 0){
									HStack{
										Icon(systemName: "clock")
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
							VStack{
								VStack(spacing: 5) {
									LeftText("Inhalt der Nachhilfestunde", font: .title3, fontWeight: .bold)
									TextEditor(text: $model.content)
										.border(.teal)
										.frame(height: 150)
								}
								
								VStack(spacing: 5) {
									LeftText("Notizen", font: .title3, fontWeight: .bold)
									TextEditor(text: $model.notes)
										.border(.teal)
										.frame(height: 150)
								}
							}
							VStack(alignment: .leading){
								Text(model.isDone ? "Die Stunde wurde absolviert" : "Die Stunde wurde noch nicht absolviert").font(.callout)
									.foregroundColor(model.isDone ? .blue : .gray)
								Text(model.isPayed ? "Die Stunde wurde bezahlt" : "Die Zahlung ist für diese Stunde noch ausstehend").font(.callout)
									.foregroundColor(model.isPayed ? .green : .gray)
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
						Spacer()
						Button("Fertig"){
							withAnimation{
								if type == .add{
									Lesson.add(student: selectedStudent, model: model)
								} else if type == .edit{
									Lesson.update(lesson: $selectedLesson, model: model)
								}
							}
							isPresented = false
						}.bold()
							.foregroundColor(.teal)
					}
				}
				.padding()
			}
		}
	}
	private func calculatePayment()->String{
		let perHour = Double(selectedStudent.payment)
		let perMinute = perHour/60.00
		let payment = perMinute * Double(model.duration)
		let paymentBonus = payment / 2 + payment
		let paymentRounded = String(format: "%.2f", paymentBonus)
		return paymentRounded + "€"
	}
}

