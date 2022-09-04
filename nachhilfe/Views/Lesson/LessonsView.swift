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
	@ObservedResults(Lesson.self, sortDescriptor: SortDescriptor(keyPath: "date", ascending: true)) var lessons
	@State var selectedStudent: Student? = nil
	
	var body: some View{
		GeometryReader{ geo in
			VStack {
				HStack{
					if selectedStudent == nil {
						Text("Alle")
							.font(.title3.weight(.bold))
					} else {
						Text(selectedStudent!.surname + " " + selectedStudent!.name)
							.font(.title3.weight(.bold))
					}
					Spacer()
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
						Text("Wählen").font(.body.weight(.regular))
							.foregroundColor(.teal)
					})
					
				}
				
				VStack(spacing: 10) {
					if selectedStudent == nil{
						ForEach(lessons, id: \.self){ lesson in
							LessonListItem(lesson: lesson, all: true)
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
							LessonListItem(lesson: lesson, all: false)
								.onTapGesture {
									withAnimation{
										selectedLesson = lesson
										editViewType = .edit
										showLessonEditView = true
									}
								}
						}
					}
				}
				Spacer()
			}.frame(width: geo.size.width)
		}
	}
}

struct LessonListItem: View{
	@Environment(\.colorScheme) var appearance
	@ObservedRealmObject var lesson: Lesson
	let all: Bool
	
	var dateFormatter: DateFormatter {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "dd. MMMM YYYY"
			dateFormatter.locale = Locale(identifier: "de_DE")
			return dateFormatter
		}

	var body: some View{
		ZStack {
			RoundedRectangle(cornerRadius: 10).fill(appearance == .dark ? Color.init(red: 30/255, green: 30/255, blue: 30/255) : Color.white)
				.shadow(radius: 1.5)
			
			HStack {
				VStack(alignment: .leading, spacing: 0) {
					HStack(spacing: 5){
						Text(dateFormatter.string(from: lesson.date))
							.font(.callout.bold())
						if all{
							Text(lesson.student.first!.surname + " " + lesson.student.first!.name)
								.font(.callout.bold())
								.foregroundColor(.teal)
						}
					}
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
					}.font(.footnote)
				}
				Spacer()
				HStack(spacing: 5){
					Image(systemName: lesson.isDone ? "checkmark.circle.fill" : "checkmark.circle")
						.resizable()
						.scaledToFit()
						.frame(width: 25)
						.onTapGesture {
							withAnimation{
								try! realmEnv.write{
									$lesson.isDone.wrappedValue.toggle()
								}
							}
						}
						.foregroundColor(lesson.isDone ? .teal : .gray)
						.opacity(lesson.isDone ? 1 : 0.5)
					
					Image(systemName: lesson.isPayed ? "eurosign.circle.fill" : "eurosign.circle")
						.resizable()
						.scaledToFit()
						.frame(width: 25)
						.onTapGesture {
							withAnimation{
								try! realmEnv.write{
									$lesson.isPayed.wrappedValue.toggle()
								}
							}
						}
						.foregroundColor(lesson.isPayed ? .green : .gray)
						.opacity(lesson.isPayed ? 1 : 0.5)
				}
			}.padding()
		}
		.fixedSize(horizontal: false, vertical: true)
	}
}
