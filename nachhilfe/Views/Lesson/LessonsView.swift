//
//  LessonsView.swift
//  nachhilfe
//
//  Created by anh :) on 14.08.22.
//

import SwiftUI
import Realm
import RealmSwift

struct LessonsView: View {
	@State var selectedLesson: Lesson? = nil
	@State var showLessonEditView: Bool = false
	@State var editViewType: EditViewTypes = .add
	
	var body: some View {
		ZStack{
			HStack{
				VStack{
					VStack(spacing: 0){
						HStack(alignment: .bottom, spacing: 10){
							Text("Übersicht").font(.system(size: 50).weight(.heavy))
							Spacer()
							Button(action: {
								withAnimation{
									selectedLesson = nil
									editViewType = .add
									showLessonEditView = true
								}
							}, label: {
								Icon(systemName: "plus")
							})
						}
						LeftText("Nachhilfestunden", font: .title2, fontWeight: .bold)
							.foregroundColor(.teal)
					}
					HStack{
						LessonList(selectedLesson: $selectedLesson, showLessonEditView: $showLessonEditView, editViewType: $editViewType)
						Divider()
						//Right: Statistics and Recents
						EmptyView()
					}
					Spacer()
				}.padding()
				if showLessonEditView {
					Divider()
					LessonEditView(type: editViewType, lesson: selectedLesson, isPresented: $showLessonEditView)
						.frame(width: 350)
				}
			}
		}
	}
}

//Lesson List with all lessons + student filter option with the "all" case
struct LessonList: View{
	@Binding var selectedLesson: Lesson?
	@Binding var showLessonEditView: Bool
	@Binding var editViewType: EditViewTypes

	@ObservedResults(Student.self) var students
	@ObservedResults(Lesson.self) var lessons
	@State var selectedStudent: Student? = nil
	
	var body: some View{
		GeometryReader{ geo in
			VStack {
				Menu(content: {
					Button(action: {
						selectedStudent = nil
					}, label: {
						HStack{
							Text("Alle")
							if selectedStudent == nil{
								Image(systemName: "checkmark")
							}
						}
					})
					
					ForEach(students, id: \.self){ student in
						Button(action: {
							selectedStudent = student
						}, label: {
							HStack{
								Text(student.surname + " " + student.name)
								if selectedStudent == student{
									Image(systemName: "checkmark")
								}
							}
						})
					}
				}, label: {
					HStack{
						Image(systemName: "line.3.horizontal.decrease.circle")
						if selectedStudent == nil {
							Text("Alle")
						} else {
							Text(selectedStudent!.surname + " " + selectedStudent!.name)
						}
						Spacer()
					}.font(.title3.weight(.semibold))
					.foregroundColor(.teal)
				})
				
				
				if selectedStudent == nil{
					ForEach(lessons, id: \.self){ lesson in
						LessonListItem(lesson: lesson)
							.onTapGesture {
								withAnimation{
									selectedLesson = lesson
									editViewType = .edit
									showLessonEditView = true
								}
							}
					}
				} else {
					ForEach(selectedStudent!.lessons, id: \.self){ lesson in
						Text(lesson.date.description)
					}
				}
				Spacer()
			}.frame(width: geo.size.width/2)
		}
	}
}

struct LessonListItem: View{
	let lesson: Lesson
	
	var dateFormatter: DateFormatter {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "dd. MMMM YYYY"
			dateFormatter.locale = Locale(identifier: "de_DE")
			return dateFormatter
		}

	var body: some View{
		ZStack {
			RoundedRectangle(cornerRadius: 5).fill(.ultraThinMaterial)
				.shadow(radius: 2.5)
			
			HStack {
				VStack(alignment: .leading, spacing: 0) {
					Text(dateFormatter.string(from: lesson.date))
						.font(.callout.bold())
					VStack{
						if lesson.isPayed && lesson.isDone{
							Text("Stunde absolviert und gezahlt")
								.foregroundColor(.teal)
						}
						if lesson.isPayed && !lesson.isDone{
							Text("Stunde gezahlt, aber noch nicht absolviert")
								.foregroundColor(.teal)
						}
						if !lesson.isPayed && lesson.isDone{
							Text("Zahlung ausstehend, Stunde absolviert")
								.foregroundColor(.red)
						}
						if !lesson.isPayed && !lesson.isDone{
							Text("Stunde weder absolviert noch gezahlt")
								.foregroundColor(.gray)
						}
					}.font(.caption)
				}
				Spacer()
				HStack(spacing: 3){
					Icon(systemName: lesson.isDone ? "checkmark.circle.fill" : "checkmark.circle", color: .blue, size: 35, isActivated: lesson.isDone)
						.onTapGesture {
							withAnimation{
								lesson.isDone.toggle()
							}
						}
					Icon(systemName: lesson.isPayed ? "eurosign.circle.fill" : "eurosign.circle", color: .green, size: 35, isActivated: lesson.isPayed)
						.onTapGesture {
							withAnimation{
								lesson.isPayed.toggle()
							}
						}
				}
			}.padding()
		}
		.fixedSize(horizontal: false, vertical: true)
	}
}
