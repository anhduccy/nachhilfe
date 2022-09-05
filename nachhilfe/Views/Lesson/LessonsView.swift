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
	@ObservedResults(Lesson.self, sortDescriptor: SortDescriptor(keyPath: "date", ascending: false)) var lessons
	@State var selectedStudent: Student? = nil
	
	@State var showAllLessons: Bool = false
	
	var body: some View{
		GeometryReader{ geo in
			VStack {
				HStack(spacing: 12.5){
					if selectedStudent == nil {
						Text("Alle")
							.font(.title3.weight(.bold))
					} else {
						Text(selectedStudent!.surname + " " + selectedStudent!.name)
							.font(.title3.weight(.bold))
					}
					Spacer()
					Button(action: {
						withAnimation{
							showAllLessons.toggle()
						}
					}, label: {
						Text(showAllLessons ? "Erledigte Stunden ausblenden" : "Alle Stunden einblenden")
							.font(.body.weight(.regular))
							.foregroundColor(.teal)
					})
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
						Text("Schüler/in wählen").font(.body.weight(.regular))
							.foregroundColor(.teal)
					})
					
				}.padding([.leading, .trailing])
					.padding(.bottom, -5)
				
				ScrollView(.vertical, showsIndicators: false){
					VStack(spacing: 10) {
						if selectedStudent == nil{
							if showAllLessons{
								ForEach(lessons, id: \.self){ lesson in
									LessonListItem(selectedLesson: $selectedLesson, lesson: lesson, showLessonEditView: $showLessonEditView, all: true)
										.onTapGesture {
											withAnimation{
												selectedLesson = lesson
												editViewType = .edit
												showLessonEditView = true
											}
										}
								}
							} else {
								ForEach(lessons.filter("isPayed == false || isDone == false"), id: \.self){ lesson in
									LessonListItem(selectedLesson: $selectedLesson, lesson: lesson, showLessonEditView: $showLessonEditView, all: true)
										.onTapGesture {
											withAnimation{
												selectedLesson = lesson
												editViewType = .edit
												showLessonEditView = true
											}
										}
								}
							}
						} else {
							if showAllLessons{
								ForEach(selectedStudent!.lessons, id: \.self){ lesson in
									LessonListItem(selectedLesson: $selectedLesson, lesson: lesson, showLessonEditView: $showLessonEditView, all: false)
										.onTapGesture {
											withAnimation{
												selectedLesson = lesson
												editViewType = .edit
												showLessonEditView = true
											}
										}
								}
							} else {
								ForEach(selectedStudent!.lessons.filter("isPayed == false || isDone == false"), id: \.self){ lesson in
									LessonListItem(selectedLesson: $selectedLesson, lesson: lesson, showLessonEditView: $showLessonEditView, all: false)
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
					}.padding([.leading, .trailing])
						.padding([.top, .bottom], 3)
				}
				Spacer()
			}.frame(width: geo.size.width)
		}
	}
}

struct LessonListItem: View{
	@Environment(\.colorScheme) var appearance
	@Binding var selectedLesson: Lesson?
	@ObservedRealmObject var lesson: Lesson
	@Binding var showLessonEditView: Bool
	let all: Bool
	
	var dateFormatter: DateFormatter {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "dd.MM.YYYY"
			dateFormatter.locale = Locale(identifier: "de_DE")
			return dateFormatter
		}

	var body: some View{
		ZStack {
			if selectedLesson?._id == lesson._id && showLessonEditView{
				RoundedRectangle(cornerRadius: 10).foregroundColor(lesson.student.first!.color.color)
					.opacity(0.1)
					.cornerRadius(10)
					.shadow(color: .teal, radius: 1.5)
			} else {
				RoundedRectangle(cornerRadius: 10).fill(appearance == .dark ? Color.init(red: 30/255, green: 30/255, blue: 30/255) : Color.white)
					.shadow(radius: 1.5)
			}
			
			HStack {
				VStack(alignment: .leading, spacing: 0) {
					HStack(spacing: 5){
						Text(dateFormatter.string(from: lesson.date))
							.font(.callout.bold())
						if all{
							Text((lesson.student.first?.surname ?? "Stunde") + " " + (lesson.student.first?.name ?? "gelöscht"))
								.font(.callout.bold())
								.foregroundColor(lesson.student.first!.color.color)
						}
					}
					VStack(alignment: .leading){
						if lesson.isPayed && lesson.isDone{
							Text("Stunde erledigt und bezahlt")
								.foregroundColor(.gray)
						}
						if lesson.isPayed && !lesson.isDone{
							Text("Vorzahlung, Stunde nicht erledigt")
								.foregroundColor(.red)
						}
						if !lesson.isPayed && lesson.isDone{
							Text("Stunde erledigt, Zahlung ausstehend")
								.foregroundColor(.red)
						}
						if !lesson.isPayed && !lesson.isDone{
							Text("Stunde nicht erledigt, Zahlung ausstehend")
								.foregroundColor(.gray)
						}
						
					}.font(.footnote)
					if lesson.content != ""{
						LeftText(lesson.content, font: .footnote).foregroundColor(.gray)
							.padding(.top, 5)
							.lineLimit(2)
					}
				}
				Spacer()
				if lesson.notes != ""{
					Image(systemName: "note.text")
						.resizable()
						.scaledToFit()
						.frame(width: 17.5)
						.foregroundColor(.gray)
				}
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
						.foregroundColor(lesson.isDone ? lesson.student.first!.color.color : .gray)
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
