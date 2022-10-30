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
	
	@State var selectedView: ViewTypes? = .home
	@State var selectedStudent: Student? = nil
	
	var body: some View{
		NavigationSplitView(sidebar: {
			List(selection: $selectedView){
				ForEach(ViewTypes.allCases, id: \.self){ view in
					NavigationLink(value: view, label: {Label(view.name, systemImage: view.image)})
				}
				if !students.isEmpty{
					Section("Alle Nachhilfeschüler", content: {
						ForEach(students.sorted(byKeyPath: "surname"), id: \.self){ student in
							NavigationLink(destination: StudentView(student: student), label: {Label("\(student.surname) \(student.name)", systemImage: "person.fill")})
						}
					})
				}
			}
		}, detail: {
			switch selectedView {
			case .lessons:
				LessonsView()
			case .exams:
				ExamView()
			default:
				HomeView()
			}
		})
	}
}
