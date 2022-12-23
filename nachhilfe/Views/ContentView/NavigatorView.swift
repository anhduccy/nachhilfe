//
//  NavigatorView.swift
//  nachhilfe
//
//  Created by anh :) on 14.08.22.
//

import SwiftUI
import Realm
import RealmSwift

struct NavigatorView: View{
	@ObservedResults(Student.self) var students
	
	@State var selectedView: ViewTypes? = .lessons
	@State var selectedStudent: Student? = nil
	@State var showStudentEditView: Bool = false
	
	var body: some View{
		NavigationSplitView(sidebar: {
			List(selection: $selectedView){
				ForEach(ViewTypes.allCases, id: \.self){ view in
					NavigationLink(value: view, label: {Label(view.name, systemImage: view.image)})
				}
				if !students.isEmpty{
					Section("Alle Nachhilfeschüler", content: {
						ForEach(students.sorted(byKeyPath: "surname"), id: \.self){ student in
							NavigationLink(destination: StudentView(student: student), label: {
								Label(title: {Text("\(student.surname) \(student.name)")}, icon: {
									Image(systemName: "person")
								})
							})
						}
					})
				}
			}
		}, detail: {
			switch selectedView {
			case .exams:
				ExamView()
			default:
				LessonsView()
			}
		}).toolbar{
			ToolbarItem{
				Button(action: {
					showStudentEditView.toggle()
				}, label: {
					Image(systemName: "plus")
				}).sheet(isPresented: $showStudentEditView){
					StudentEditView(type: .add, student: nil, isPresented: $showStudentEditView)
				}
			}
		}
	}
}

