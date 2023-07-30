//
//  ExamEditView.swift
//  nachhilfe
//
//  Created by anh :) on 10.09.22.
//

import SwiftUI
import RealmSwift

struct ExamEditView: View {
	init(type: EditViewTypes, exam: Exam?, student: Student? = nil, isPresented: Binding<Bool>){
		_isPresented = isPresented
		self.type = type
		if type == .add{
			let internModel = ExamModel()
			if student != nil{
				internModel.student = student!
			}
			self.model = internModel
			self.exam = Exam()
		} else{
			self.model = ExamModel().toLayer(exam: exam!)
			self.exam = exam!
		}
		
	}
	@Environment(\.colorScheme) var appearance
	@Binding var isPresented: Bool
    let type: EditViewTypes
	
	@ObservedResults(Student.self) var students
    @ObservedRealmObject var exam: Exam
	@ObservedObject var model: ExamModel
	
	var dateFormatter: DateFormatter {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd. MMMM YYYY"
		dateFormatter.locale = Locale(identifier: "de_DE")
		return dateFormatter
	}
	
	let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 8)
	@State var placeholderText: String = "Themen eingeben"
	    
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
							if model.student.surname.isEmpty && model.student.name.isEmpty{
								LeftText("Klausur hinzufügen", font: .title, fontWeight: .bold)
									.foregroundColor(model.student.color.color)
								LeftText("Tippe um Auszuwählen", font: .callout)
									.foregroundColor(.gray)
							} else {
								LeftText("\(model.student.surname) \(model.student.name)", font: .title, fontWeight: .bold)
									.foregroundColor(model.student.color.color)
								if type == .add{
									LeftText("Klausur hinzufügen", font: .callout)
										.foregroundColor(.gray)
								} else {
									LeftText("Klausur am \(dateFormatter.string(from: model.date))", font: .callout)
										.foregroundColor(.gray)
								}
							}
						}
					})
					Spacer()
				}
				ScrollView(.vertical, showsIndicators: false){
					VStack(spacing: 35){
						HStack{
							Icon(systemName: "calendar", color: model.student.color.color)
							DatePicker(selection: $model.date, displayedComponents: [.date], label: {})
								.datePickerStyle(.compact)
						}
						VStack(spacing: 0){
							LazyVGrid(columns: columns){
								ForEach(0..<16, id: \.self){ grade in
									ZStack{
										Circle().fill(model.grade == grade ? model.student.color.color : .gray)
											.opacity(model.grade == grade ? 0.2 : 0.5)
										Text("\(grade)")
											.foregroundColor( model.grade == grade ? model.student.color.color : .white)
									}.onTapGesture {
										if grade != model.grade{
											model.grade = grade
										} else {
											model.grade = -1
										}
									}
								}
							}
						}
						VStack(spacing: 5) {
							LeftText("Klausurthemen", font: .title3, fontWeight: .bold)
							ZStack {
								if model.topics.isEmpty {
										TextEditor(text:$placeholderText)
											.font(.body)
											.foregroundColor(.gray)
											.disabled(true)
								}
								TextEditor(text: $model.topics)
									.font(.body)
									.opacity(model.topics.isEmpty ? 0.25 : 1)
							}
							.padding(.leading, -5)
						}
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
								Exam.delete(exam: exam)
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
								Exam.add(model: model)
							} else if type == .edit{
								Exam.update(exam: $exam, model: model)
							}
							isPresented = false
						}
					}.bold()
						.disabled(model.student.surname.isEmpty && model.student.name.isEmpty)
						.foregroundColor(model.student.surname.isEmpty && model.student.name.isEmpty ? .gray : model.student.color.color)
				}
			}
		}
		.padding(20)
    }
}
